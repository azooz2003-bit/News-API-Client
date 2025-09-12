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

    // MARK: Views

    @IBOutlet var scrollView: NSScrollView!

    /// Vertical container for sidebar items inside the scroll view.
    private var stackView: NSStackView!
    /// Reminders-like grid. Featuring: Top Headlines, Apple
    private var tabsCollectionView: NSCollectionView!
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

        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .overlay
        scrollView.documentView = stackView

        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            // NOTE: bottom anchor constraint is not set to allow content to expand under bottom edge
        ])

        setupTabsCollectionView()
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        tabsCollectionView.collectionViewLayout?.invalidateLayout()
    }
}

// MARK: Grid

extension SidebarViewController {
    var gridTabs: [GridTab] {
        [.topHeadlines, .apple]
    }

    var numberOfGridColumns: Int {
        2
    }

    var numberOfGridRows: Int {
        let avgItemsPerRow = Double(gridTabs.count) / Double(numberOfGridColumns)
        return Int(ceil(avgItemsPerRow))
    }

    var spacing: CGFloat {
        8
    }

    var sectionHorizontalInset: CGFloat {
        12
    }

    var itemHeight: CGFloat {
        50
    }

    var collectionViewHeight: CGFloat {
        CGFloat(numberOfGridRows) * itemHeight + CGFloat(numberOfGridRows - 1) * spacing
    }

    private func setupTabsCollectionView() {
        tabsCollectionView = NSCollectionView()

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = NSEdgeInsets(top: 0, left: sectionHorizontalInset, bottom: 0, right: sectionHorizontalInset)

        tabsCollectionView.collectionViewLayout = flowLayout
        tabsCollectionView.enclosingScrollView?.hasHorizontalScroller = false
        tabsCollectionView.enclosingScrollView?.hasVerticalScroller = false
        tabsCollectionView.delegate = self
        tabsCollectionView.dataSource = self

        tabsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(tabsCollectionView)

//        tabsCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true

        // Register grid cell
        let nib = NSNib(nibNamed: SidebarGridCell.nibName, bundle: nil)
        tabsCollectionView.register(nib, forItemWithIdentifier: SidebarGridCell.identifier)
    }
}

extension SidebarViewController: NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    // MARK: NSCollectionViewDataSource

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        gridTabs.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cellItem = collectionView.makeItem(withIdentifier: SidebarGridCell.identifier, for: indexPath) as! SidebarGridCell

        cellItem.configure(with: gridTabs[indexPath.item])

        return cellItem
    }

    // MARK: NSCollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let widthTakenBySpacing = spacing * CGFloat(numberOfGridColumns - 1)
        let widthTakenByInsets = 2*sectionHorizontalInset
        let availableWidth = collectionView.bounds.width - widthTakenByInsets - widthTakenBySpacing
        let itemWidth = availableWidth / CGFloat(numberOfGridColumns)

        return NSSize(width: itemWidth, height: itemHeight)
    }
}
