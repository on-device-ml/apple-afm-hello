///
///  # AppDelegate.swift
///
/// - Author: Created by Geoff G. on 07/30/2025
///
///

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Set the minimum window size
        let window = NSApplication.shared.windows.first
        window?.minSize = AppConstants.Display.displayMinSize
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

