//
//  MainSplitViewController.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 8/24/25.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    var sidebarVC: SidebarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSplitView()
    }

    private func setupSplitView() {
        self.sidebarVC = SidebarViewController.create()
        let sidebarItem = NSSplitViewItem(sidebarWithViewController: sidebarVC)
        sidebarItem.canCollapse = true
        sidebarItem.maximumThickness = 300

        let placeholderVC1 = NSViewController()
        placeholderVC1.view = NSView()
//        placeholderVC1.view.wantsLayer = true
//        placeholderVC1.view.layer?.backgroundColor = NSColor.systemGreen.cgColor

        let placeholderVC2 = NSViewController()
        placeholderVC2.view = NSView()
//        placeholderVC2.view.wantsLayer = true
//        placeholderVC2.view.layer?.backgroundColor = NSColor.systemBlue.cgColor

        let splitViewItems: [NSSplitViewItem] = [
            sidebarItem,
            NSSplitViewItem(viewController: placeholderVC1),
            NSSplitViewItem(viewController: placeholderVC2)
        ]
        splitViewItems[1].minimumThickness = 200
        splitViewItems[2].minimumThickness = 200

        self.splitViewItems = splitViewItems
    }
}
