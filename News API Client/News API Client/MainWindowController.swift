//
//  MainWindowController.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 8/24/25.
//


import Cocoa

class MainWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()

        window?.title = "News"
        window?.center()
        window?.setFrameAutosaveName(Self.className())
        window?.isReleasedWhenClosed = true
    }

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 1000),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        self.init(window: window)
    }
}
