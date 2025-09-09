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

        window?.setContentSize(NSSize(width: 1200, height: 1000))
        window?.center()

        let toolbar = NSToolbar(identifier: .init("MainWindowToolbar"))
        toolbar.delegate = self

        window?.toolbar = toolbar
    }
}

extension MainWindowController: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            .flexibleSpace,
            .toggleSidebar,
            .sidebarTrackingSeparator,
            .showFonts,
            .flexibleSpace,
            .showColors
            // TODO: add search here
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        toolbarDefaultItemIdentifiers(toolbar)
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var toolbarItem: NSToolbarItem?

        switch itemIdentifier {
        case .toggleSidebar:
            toolbarItem = NSToolbarItem(itemIdentifier: .toggleSidebar)
            toolbarItem?.image = .leftSidebar
            toolbarItem?.isBordered = true
        case .sidebarTrackingSeparator:
            toolbarItem = NSToolbarItem(itemIdentifier: .sidebarTrackingSeparator)
        default:
            toolbarItem = nil
        }

        return toolbarItem
    }
}
