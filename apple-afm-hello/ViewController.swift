///
///  # ViewController.swift
///
/// - Author: Created by Geoff G. on 07/30/2025
///
/// - Description:
///
///    - Explores the basics of using Apple's on-device Intelligence Foundation Model, including:
///         - Checking for Apple Intelligence on device
///         - Configuring basic model parameters
///         - Prompting the foundation model
///         - Processing streaming output
///
/// - Important:
///
///    - Apple's approach to on-device large language models focuses on specific tasks and excels at processing natural
///    - language, rather than providing general world knowledge or advanced reasoning capabilities typically associated
///    - with larger, cloud-based LLMs.
///    -
///    - To address the limitations, developers should use @Generable types to force structure to the output of the LLM,
///    - and further refine output with tool calling using external data sources or services within an app.
///    -
///    - For more complex tasks requiring greater computational capacity or access to a wider range of knowledge, Apple
///    - offers Private Cloud Compute, which uses larger, server-based models running on Apple silicon while maintaining
///    - user privacy guarantees.
///
/// - Seealso:
///
///    - WWDC25: Meet the Foundation Models framework: https://www.youtube.com/watch?v=mJMvFyBvZEk
///    - WWDC25: Deep dive into the Foundation Models framework https://www.youtube.com/watch?v=6Wgg7DIY29E
///    - WWDC25: Code-along: Bring on-device AI to your app using the Foundation Models framework https://www.youtube.com/watch?v=XuX66Oljro0
///    - WWDC25: Explore prompt design & safety for on-device foundation models https://www.youtube.com/watch?v=-aMFBj-kwdU
///    - WWDC25: Discover machine learning & AI frameworks on Apple platforms https://www.youtube.com/watch?v=wzQlws_Hxfw
///    - WWDC25: Explore large language models on Apple silicon with MLX https://www.youtube.com/watch?v=tn2Hvw7eCsw
///    - WWDC25: Get started with MLX for Apple silicon https://www.youtube.com/watch?v=UbzOBg8fsxo
///
///    - https://machinelearning.apple.com/research/introducing-apple-foundation-models
///    - https://machinelearning.apple.com/research/apple-foundation-models-tech-report-2025
///    - https://machinelearning.apple.com/research/apple-foundation-models-2025-updates
///    - https://developer.apple.com/documentation/FoundationModels
///    - https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel
///    - https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models?language=objc
///    - https://dimillian.medium.com/bringing-on-device-ai-to-your-app-using-apples-foundation-models-8a1df297eeaa
///    - https://machinelearning.apple.com/research/apple-foundation-models-2025-updates
///    - https://medium.com/@richardmoult75/macos-26-tahoe-apple-intelligence-repeated-responses-e0099995f3eb
///    - https://alessiorubicini.medium.com/getting-hands-on-with-apples-foundation-models-framework-2bebc059db06
///

import Cocoa
import Foundation
import FoundationModels

// MARK: App Constants

/// --------------------------------------------------------------------------------
/// Application Constants
///
struct AppConstants {
    
    struct Strings {
        
        static let appTitle = "Apple Foundation Models | Hello 🙂"
        
        static let rolePlaceholder = "Enter a role that describes how the model should respond to your questions"
        static let promptPlaceholder = "Ask me anything, then select  \u{25B6}"
    }
    
    struct Fonts {
        
        // Other readable fonts: SF Pro
        static let fontNormal=NSFont(name: "Avenir Next Regular", size: 18)
        static let fontBold=NSFont(name: "Avenir Next Bold", size: 18)
    }
    
    struct Attributes {
        
        // Used to format attributed strings
        static let paraAlignRight: NSMutableParagraphStyle = {
                let style = NSMutableParagraphStyle()
                style.alignment = .right
                return style
        }()
        
        static let attrResponsePrompt: [NSAttributedString.Key: Any] = {
            return [
                .font: AppConstants.Fonts.fontBold!,
                .foregroundColor: NSColor(named:"ResponsePromptColor")!,
                .paragraphStyle: paraAlignRight
            ]
        }()
        
        static let attrResponse: [NSAttributedString.Key: Any] = {
            return [
                .font: AppConstants.Fonts.fontNormal!,
                .foregroundColor: NSColor(named:"ResponseColor")!
            ]
        }()
        
        static let attrError: [NSAttributedString.Key: Any] = {
            return [
                .font: AppConstants.Fonts.fontNormal!,
                .foregroundColor: NSColor(named:"ErrorColor")!
            ]
        }()
    }
    
    struct Display {
        
        static let displayMinSize = NSMakeSize(842,482)
        static let displayInset = NSMakeSize(10, 10)
    }
    
    struct Model {
        
        static let defaultRole = "You are a helpful assistant "
        
        // Max tokens allowed in a response
        static let maximumResponseTokens = 4096 // Default: 1024
        
        // Temperature Reference: How creative/predictable the model is
        //
        // 0.0       = Completely deterministic. Always picks the highest-probability token (like greedy decoding).
        // 0.2       = Very low randomness. Responses are safe, repetitive, and factual.
        // 0.5       = Moderately deterministic. Good for clarity and fluency.
        // 0.7       = Balanced creativity and coherence. A common default.
        // 1.0       = High creativity and variation. Risk of going off-topic.
        // 1.2 – 1.5 = Very random, often less coherent. Used for wild brainstorming or experimental outputs.
        //
        static let tempDefault = 0.2
        static let tempMin = 0.0
        static let tempMax = 2.0

        // Top-K Reference: The number of tokens to consider
        //
        //  1 = Only selects the most likely token (greedy decoding).
        //      Very deterministic, but can be repetitive and uncreative.
        //      Factual answers, consistent outputs
        //
        //  5 = Chooses from top 5 tokens. Adds some randomness but still very focused.
        //      Short answers, constrained writing
        //
        //  20 = Moderate randomness. Allows some creativity with reasonable coherence.
        //      Conversational bots, summaries
        //
        //  40–50 = Common default in many LLMs (like GPT-3). Good mix of coherence and creativity.
        //      General-purpose text generation
        //
        //  100 = High diversity, more creative or surprising responses. May lose coherence slightly.
        //      Brainstorming, storytelling
        //
        //  200+ = Very wide choice range. High variability, may generate off-topic or incoherent text.
        //      Poetry, ideation, joke writing
        //
        static let topK = 50
    }
}

// MARK: Class

class ViewController: NSViewController {

    private var modelAvailable : Bool
    private var llmModel : SystemLanguageModel?
    private var llmSession : LanguageModelSession?
    private var shouldStop : Bool?

    @IBOutlet weak var textRole: MyTextView!
    @IBOutlet weak var textPrompt: MyTextView!
    @IBOutlet weak var textResponse: MyTextView!
    
    @IBOutlet weak var textModelTemp: NSTextField!
    @IBOutlet weak var sliderModelTemp: NSSlider!
    
    @IBOutlet weak var progressInference: NSProgressIndicator!
    
    @IBOutlet weak var btnClear: NSButton!
    @IBOutlet weak var btnStop: NSButton!
    @IBOutlet weak var btnGenerate: NSButton!
    
    /// Initializes properties of the view controller
    ///
    /// - Parameters:
    ///   - aDecoder -
    ///
    required init?(coder aDecoder: NSCoder) {
        
        modelAvailable = false
        llmModel = nil
        llmSession = nil
        shouldStop = false
        
        super.init(coder: aDecoder)
    }
    
    // MARK: User Interface - Overrides
    
    /// --------------------------------------------------------------------------------
    /// Initializes properties of the view controller
    ///
    override func viewDidLoad() {
        
        super.viewDidLoad()

        textRole.isEditable = true
        textRole.isSelectable = true
        textRole.placeholderString = AppConstants.Strings.rolePlaceholder
        textRole.string = AppConstants.Model.defaultRole
        textRole.textColor = NSColor(named: "RoleColor")
        textRole.backgroundColor = NSColor(named: "TextBackgroundColor")!
        textRole.font = AppConstants.Fonts.fontNormal
        textRole.textContainerInset = AppConstants.Display.displayInset;
        textRole.toolTip = AppConstants.Strings.rolePlaceholder
        
        textPrompt.isEditable = true
        textPrompt.isSelectable = true
        textPrompt.placeholderString = AppConstants.Strings.promptPlaceholder
        textPrompt.textColor = NSColor(named: "PromptColor")
        textPrompt.backgroundColor = NSColor(named: "TextBackgroundColor")!
        textPrompt.font = AppConstants.Fonts.fontNormal
        textPrompt.textContainerInset = AppConstants.Display.displayInset;
        textPrompt.toolTip = AppConstants.Strings.promptPlaceholder
        
        textResponse.isEditable = false
        textResponse.isSelectable = true
        textResponse.textColor = NSColor(named: "ResponseColor")
        textResponse.backgroundColor = NSColor(named: "TextBackgroundColor")!
        textResponse.font = AppConstants.Fonts.fontNormal
        textResponse.textContainerInset = AppConstants.Display.displayInset;
        
        textModelTemp.alignment = .center
        textModelTemp.translatesAutoresizingMaskIntoConstraints = false
        textModelTemp.stringValue = String(format: "%0.1f",AppConstants.Model.tempDefault)
        
        sliderModelTemp.isContinuous = false
        sliderModelTemp.target = self
        sliderModelTemp.action = #selector(sliderValueChanged(_:))
        sliderModelTemp.minValue = AppConstants.Model.tempMin
        sliderModelTemp.maxValue = AppConstants.Model.tempMax
        sliderModelTemp.doubleValue = AppConstants.Model.tempDefault
        let numTicks = Int((AppConstants.Model.tempMax-AppConstants.Model.tempMin)/0.1)
        sliderModelTemp.numberOfTickMarks = numTicks
        sliderModelTemp.allowsTickMarkValuesOnly = true
        
        btnClear.image = NSImage(systemSymbolName: "doc", accessibilityDescription: nil)!
        btnClear.toolTip = "Clear Chat History"
        
        btnStop.image = NSImage(systemSymbolName: "stop.fill", accessibilityDescription: nil)!
        btnStop.toolTip = "Stop Generating"
        
        btnGenerate.image = NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)!
        btnGenerate.toolTip = "Start Generating"
    }

    /// --------------------------------------------------------------------------------
    /// viewWillAppear
    ///
    override func viewWillAppear() {
        
        self.view.window?.title = AppConstants.Strings.appTitle
    
        // Initialize our model
        self.modelAvailable = self.checkModelAvailable()
        if ( !self.modelAvailable ) {
            
            self.printError(msg: "􀇾 Cannot proceed")
            self.toggleControls(enabled: false)
        }
    }
    
    // MARK: Model - Availability

    /// --------------------------------------------------------------------------------
    /// Verifies the existance of the Apple Foundation SystemLanguageModel
    ///
    /// - Returns: Bool - the status of the operation
    ///
    func checkModelAvailable() -> Bool {
        
        if #unavailable(macOS 15) {
            fatalError("􀇾 This app requires macOS 15 or later to use Apple Foundation Models")
        }
        
        // Can we access the Apple Intelligence model?
        self.llmModel = FoundationModels.SystemLanguageModel(useCase: SystemLanguageModel.UseCase.general)
        switch self.llmModel!.availability {
            
            case .unavailable(let reason):
                switch reason {
                    case .deviceNotEligible:
                    printError(msg: "􀇾 Device not eligible for Apple Intelligence.")
                    case .appleIntelligenceNotEnabled:
                    printError(msg: "􀇾 Apple Intelligence is not enabled. Under Settings, select Apple Intelligence & Siri, then enable Apple Intelligence.")
                    case .modelNotReady:
                    printError(msg: "􀇾 Model is not ready. It may be still downloading or initializing.")
                    @unknown default:
                    printError(msg: "􀇾 The SystemLanguageModel is not available.")
                }
                self.toggleControls(enabled: false)
                return false
            
            case .available:
                break
        }
        return true
    }
    
    // MARK: User Interface - Buttons/Sliders

    /// --------------------------------------------------------------------------------
    /// Clears the contents of fields and enables the role field again
    ///
    /// - Parameters:
    ///   - sender -
    ///
    @IBAction func btnClear(_ sender: Any) {
        
        // Is our model available?
        if ( !self.modelAvailable || self.llmModel == nil ) {
            return
        }
        
        // Reset LLM Session
        self.llmSession = nil
        
        // Reset Fields
        self.textRole.isEditable = true;
        self.textRole.string = AppConstants.Model.defaultRole
        self.textPrompt.string = ""
        self.textResponse.string = ""
        self.shouldStop = false
        sliderModelTemp.doubleValue = AppConstants.Model.tempDefault
        textModelTemp.stringValue = String( format: "%0.1f", AppConstants.Model.tempDefault)
    }
    
    /// --------------------------------------------------------------------------------
    /// Stops generating tokens
    ///
    /// - Parameters:
    ///   - sender -
    ///
    @IBAction func btnStop(_ sender: Any) {
        
        // Is our model available?
        if ( !self.modelAvailable || self.llmModel == nil ) {
            return
        }
        self.shouldStop = true
    }
    
    /// --------------------------------------------------------------------------------
    /// Starts generating with the on-device SystemLanguageModel using the specified prompt
    ///
    /// - Parameters:
    ///   - sender -
    ///
    @IBAction func btnGenerate(_ sender: Any) {
        
        // Is our model available?
        if ( !self.modelAvailable || self.llmModel == nil ) {
            return
        }
        
        // Do we have a Prompt
        var prompt : String = self.textPrompt.string
        prompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        if ( prompt.isEmpty ) {
            return;
        }

        // Prepare controls for model responses
        self.startedResponse(prompt: prompt)
                    
        // Role
        var role : String = self.textRole.string
        if ( role.isEmpty ) {
            role = AppConstants.Model.defaultRole
            self.textRole.string = AppConstants.Model.defaultRole
        }
        
        // Temperature
        let tempSelected = Double(self.textModelTemp.stringValue)
        
        // Is our session initialized?
        if ( self.llmSession == nil ) {
            self.llmSession = LanguageModelSession(instructions: role)
        }
        
        Task {
            
            // Initialize our model options (Ref: AppConstants.Model for info)
            let options = GenerationOptions(
                sampling: .random(top: AppConstants.Model.topK),
                temperature: tempSelected,
                maximumResponseTokens: AppConstants.Model.maximumResponseTokens)
            
            // Start text generation
            let stream = self.llmSession!.streamResponse(to: prompt,
                                                    options: options)
            
            // Stream the output to the response field
            var lastChunk : String = ""
            for try await thisChunk in stream {
                
                // Have we been asked to stop?
                if ( self.shouldStop! ) {
                    break;
                }
                
                // Append whats changed
                let delta = String(thisChunk.dropFirst(lastChunk.count))
                self.appendResponse(text: delta,
                                    attr: AppConstants.Attributes.attrResponse as NSDictionary)
                
                lastChunk = thisChunk
            }
            
            // Update controls following responses
            self.finishedResponse()
        }
    }
        
    /// --------------------------------------------------------------------------------
    /// Called to update the text field when the user adjusts the model temperature slider
    ///
    /// - Parameters:
    ///   - sender:
    ///
    @objc func sliderValueChanged(_ sender: NSSlider) {
        
        textModelTemp.stringValue = String( format: "%0.1f", sender.doubleValue)
    }

    // MARK: User Interface - Fields

    /// --------------------------------------------------------------------------------
    /// Displays a message in the response window
    ///
    /// - Parameters:
    ///   - msg - the message to display
    ///
    func printError(msg: String) {
        
        self.appendResponse(text: msg,
                            attr: AppConstants.Attributes.attrError as NSDictionary )
    }
    
    /// --------------------------------------------------------------------------------
    /// Appends the prompt to the response
    ///
    /// - Parameters:
    ///   - prompt: the prompt string to append
    ///
    private func appendPromptToResponse(prompt : String) {
        
        DispatchQueue.main.async {
            
            var nl : String = ""
            if ( !self.textResponse.string.isEmpty ) {
                nl = "\n\n"
            }
            let text = String(format:"%@%@\n\n",nl,prompt)
            self.appendResponse( text: text,
                                 attr: AppConstants.Attributes.attrResponsePrompt as NSDictionary )
        }
    }

    /// --------------------------------------------------------------------------------
    /// Updates text in the response field
    ///
    /// - Parameters:
    ///   - text: the text string to append
    ///   - attr: the attributes to apply to the text
    ///
    private func updateResponse(text : String,
                                attr : NSDictionary ) {
        
        DispatchQueue.main.async {
            
            let attrText = NSAttributedString(string: text, attributes: attr as? [NSAttributedString.Key : Any])
            self.textResponse.textStorage?.setAttributedString(attrText)
            self.textResponse.scrollToEndOfDocument(nil)
        }
    }
    
    /// --------------------------------------------------------------------------------
    /// Appends text to the response field
    ///
    /// - Parameters:
    ///   - text: the text string to append
    ///   - attr: the attributes to apply to the text
    ///
    private func appendResponse(text : String,
                                attr : NSDictionary ) {
        
        DispatchQueue.main.async {
            
            let attrText = NSAttributedString(string: text, attributes: attr as? [NSAttributedString.Key : Any])
            self.textResponse.textStorage?.append(attrText)
            self.textResponse.scrollToEndOfDocument(nil)
        }
    }

    /// --------------------------------------------------------------------------------
    /// Prepares controls for a series of responses
    ///
    private func startedResponse( prompt: String ) {
        
        DispatchQueue.main.async {

            self.appendPromptToResponse(prompt: prompt)
            
            // Freeze our Role field after the first call. Use btnClear to reset
            if ( self.textResponse.string.isEmpty ) {
                self.textRole.isEditable = false;
            }
            self.toggleControls(enabled: false)
            self.progressInference.startAnimation(self)
        }
    }

    /// --------------------------------------------------------------------------------
    /// Finalizes controls once the responses have finished
    ///
    private func finishedResponse() {
        
        DispatchQueue.main.async {
            self.appendResponse(text: "\n",
                                attr: AppConstants.Attributes.attrResponse as NSDictionary)
            self.toggleControls(enabled: true)
            self.progressInference.stopAnimation(self)
        }
    }

    /// --------------------------------------------------------------------------------
    /// Selectively enable/disable UI controls
    ///
    /// - Parameters:
    ///   - enabled: whether the controls are enabled
    ///
    private func toggleControls(enabled : Bool) {
        
        DispatchQueue.main.async {
            
            self.textPrompt.isEditable = enabled
            self.btnClear.isEnabled = enabled
            self.btnGenerate.isEnabled = enabled
        }
    }
}

