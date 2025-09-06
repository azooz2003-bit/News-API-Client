//
//  SidebarViewController.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 8/24/25.
//

import Cocoa

class SidebarViewController: NSViewController {
    static func create() -> SidebarViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("SidebarViewController"), bundle: nil)

        let sidebarVC = storyboard.instantiateController(withIdentifier: "SidebarViewController")

        return sidebarVC as! SidebarViewController
    }

    @IBOutlet weak var scrollView: NSScrollView!

    private var stackView: NSStackView!
    /// Top Headlines, Apple
    private var gridView: NSGridView!
    /// Favorites section
    private var tableView: NSTableView!

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            // NOTE: bottom anchor constraint is not set to allow content to expand under bottom edge
        ])
    }

    private func setupGridView() {

    }

    private func setupFavoritesListView() {

    }
}
