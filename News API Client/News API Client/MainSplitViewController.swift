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

        let splitViewItems: [NSSplitViewItem] = [
            NSSplitViewItem(sidebarWithViewController: sidebarVC),
        ]

        self.splitViewItems = splitViewItems
    }
}
