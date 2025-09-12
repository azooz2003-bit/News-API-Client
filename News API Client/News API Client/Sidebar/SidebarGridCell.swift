//
//  SidebarGridCell.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/9/25.
//

import Cocoa

class SidebarGridCell: NSCollectionViewItem {
    static let nibName: String = "SidebarGridCell"
    static let identifier = NSUserInterfaceItemIdentifier("SidebarGridCell")

    @IBOutlet var backgroundContainer: NSView!
    @IBOutlet var iconCircleContainer: NSBox!
    @IBOutlet var iconImageView: NSImageView!
    @IBOutlet var cellTitle: NSTextField!

    // MARK: Settable
    var icon: NSImage!
    var name: String!
    var tintColor: NSColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        setupSubviews()
    }

    private func setupConstraints() {
        iconCircleContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        cellTitle.translatesAutoresizingMaskIntoConstraints = false

        // Center icon circle container in cell + 44x44 size
        NSLayoutConstraint.activate([
           iconCircleContainer.widthAnchor.constraint(equalToConstant: 44),
           iconCircleContainer.heightAnchor.constraint(equalToConstant: 44),
            iconCircleContainer.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            iconCircleContainer.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor)
        ])

        // Horizontally center title & place it between icon and bottom edge
        NSLayoutConstraint.activate([
            cellTitle.topAnchor.constraint(equalTo: iconCircleContainer.bottomAnchor, constant: 5),
            cellTitle.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -5),
            cellTitle.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor)
        ])

        // Center image in circle container + 24x24 size
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: iconCircleContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconCircleContainer.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupSubviews() {
        backgroundContainer.wantsLayer = true
        backgroundContainer.layer?.cornerRadius = 8
        // TODO: setup gradient
        backgroundContainer.layer?.backgroundColor = tintColor.cgColor

        iconCircleContainer.fillColor = .white

        cellTitle.textColor = .white
        cellTitle.alignment = .center
        cellTitle.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        cellTitle.stringValue = name

        iconImageView.image = icon
    }

    func configure(with gridTab: GridTab) {
        self.icon = gridTab.symbol
        self.name = gridTab.title
        self.tintColor = gridTab.tintColor

        backgroundContainer.layer?.backgroundColor = tintColor.cgColor
        cellTitle.stringValue = name
        iconImageView.image = icon
    }
}
