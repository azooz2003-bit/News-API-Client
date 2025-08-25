//
//  MainSplitViewController.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 8/24/25.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSplitView()
    }

    private func setupSplitView() {
        let splitViewItems: [NSSplitViewItem] = [
//            NSSplitViewItem(viewController: NewsListViewController()),
        ]

        for splitViewItem in splitViewItems {
            addSplitViewItem(splitViewItem)
        }
        self.splitViewItems = splitViewItems
    }
}
