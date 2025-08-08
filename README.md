# apple-afm-hello

Explores new features of the 2025 Apple Foundation Models Framework via a simple chat interface

![apple-intelligence](https://github.com/on-device-ml/apple-afm-hello/blob/main/aah-screenshot.jpg)

[Watch the video](https://youtu.be/u2TmntURokM)

## Overview
Explores the basics of using Apple's on-device Intelligence Foundation Model, including:<br><br>
    - Checking the availability of Apple Intelligence on a device<br>
    - Configuring basic model parameters<br>
    - Prompting the foundation model<br>
    - Processing streaming output<br>

## Quick Start

⚡️ To get started, assuming a ~/MyProjects project folder:

<pre>
1) Clone apple-afm-hello to ~/MyProjects

2) Use XCode to build ~/MyProjects/apple-afm-hello

3) Run & enter a question in the prompt field, then select ⏵
</pre>

## Before We Start

- Apple's approach to on-device large language models focuses on specific tasks and excels at processing natural 
language, rather than providing general world knowledge or advanced reasoning capabilities typically associated
with larger, cloud-based LLMs.

- To address the limitations, developers should use @Generable types to force structure to the output of the LLM,
and further refine output with tool calling using external data sources or services within an app.

- For more complex tasks requiring greater computational capacity or access to a wider range of knowledge, Apple
offers Private Cloud Compute, which uses larger, server-based models running on Apple silicon while maintaining
user privacy guarantees.

- Requires macOS Tahoe 26+

- Requires building with XCode 26+

## Target Environment

Modules targeted for these **Devices:**<br>
<pre>
 - Apple Silicon M-series Macs such as M1, M2, M3, M4 and their Pro, Max, and Ultra versions
</pre>

...**O/S versions:**<br>
<pre>
- macOS Tahoe 26+
</pre>


## Development and Test Environments

Modules created/tested using these **Devices:**<br>
<pre>
- MacBook M4 Max 32Gb
- MacBook M4 16Gb
- MacBook M1 16Gb
</pre>

...**O/S versions:**<br>
<pre>
- macOS Tahoe 26 (25A5316i)
</pre>

...**XCode versions:**<br>
<pre>
- XCode 26 beta (17A5241e)
- XCode 26 beta (17A5285i)
</pre>
    
...**Themes:**<br>
<pre>
Developed & tested mainly in dark mode 🌙
</pre>


## Additional References

- [WWDC25: Meet the Foundation Models framework](https://www.youtube.com/watch?v=mJMvFyBvZEk)
- [WWDC25: Deep dive into the Foundation Models framework](https://www.youtube.com/watch?v=6Wgg7DIY29E)
- [WWDC25: Code-along: Bring on-device AI to your app using the Foundation Models framework](https://www.youtube.com/watch?v=XuX66Oljro0)
- [WWDC25: Explore prompt design & safety for on-device foundation models](https://www.youtube.com/watch?v=-aMFBj-kwdU)
- [WWDC25: Discover machine learning & AI frameworks on Apple platforms](https://www.youtube.com/watch?v=wzQlws_Hxfw)
- [WWDC25: Explore large language models on Apple silicon with MLX](https://www.youtube.com/watch?v=tn2Hvw7eCsw)
- [WWDC25: Get started with MLX for Apple silicon](https://www.youtube.com/watch?v=UbzOBg8fsxo)

- https://machinelearning.apple.com/research/introducing-apple-foundation-models
- https://machinelearning.apple.com/research/apple-foundation-models-tech-report-2025
- https://machinelearning.apple.com/research/apple-foundation-models-2025-updates
- https://developer.apple.com/documentation/FoundationModels
- https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel
- https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models?language=objc
- https://dimillian.medium.com/bringing-on-device-ai-to-your-app-using-apples-foundation-models-8a1df297eeaa
- https://machinelearning.apple.com/research/apple-foundation-models-2025-updates
- https://medium.com/@richardmoult75/macos-26-tahoe-apple-intelligence-repeated-responses-e0099995f3eb
- https://alessiorubicini.medium.com/getting-hands-on-with-apples-foundation-models-framework-2bebc059db06

## Feedback and Contributions

Feedback & suggestions are welcome! Please, feel free to [get in touch](https://github.com/apple-intelligence/apple-afm-hello).
