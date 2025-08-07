///
///  # MyTextView.swift
///
/// - Author: Created by Geoff G. on 07/30/2025
///
/// - Description:
///
///    - NSTextView subclass to support arbitrary stuff
///

import Cocoa

class MyTextView: NSTextView {

    // Placeholder string is not supported by default in NSTextView
    var placeholderString: String?

    /// --------------------------------------------------------------------------------
    /// awakeFromNib
    ///
    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
    }

    /// --------------------------------------------------------------------------------
    /// Required to update placeholder, which is not supported by NSTextView
    ///
    /// - Parameters:
    ///   - dirtyRect:
    ///
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // If there is no text, draw the placeholder
        if string.isEmpty, let placeholder = placeholderString {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor.placeholderTextColor,
                .font: self.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
            ]
            let rect = NSInsetRect(bounds,14, 10)
            placeholder.draw(in: rect,
                withAttributes: attributes)
        }
    }

    /// --------------------------------------------------------------------------------
    /// Required to update placeholder, which is not supported by NSTextView
    ///
    override func didChangeText() {
        super.didChangeText()
        needsDisplay = true
    }
    
}
