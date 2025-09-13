//
//  BrowsingTabsContainerCell.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class BrowsingTabsContainerCell: UITableViewCell {

    static let identifier = "BrowsingTabsContainerCell"

    var collectionView: UICollectionView!
    var collectionViewHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Initial Setup

    private func setupCollectionView() {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.spacing
        layout.minimumLineSpacing = Constants.spacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        // TODO: register cell
        collectionView.register(BrowsingTabCell.self, forCellWithReuseIdentifier: BrowsingTabCell.identifier)

        contentView.addSubview(collectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionViewHeightConstraint
        ])
    }

    /// Call after initializing to connect data.
    func setCollectionViewDataSourceDelegate(_ delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        collectionView.dataSource = delegate
        collectionView.delegate = delegate

        if contentView.bounds.width > 0 {
            setCollectionViewLayoutForCurrentBounds()
        }

        collectionView.reloadData()
    }

    // MARK: Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        setCollectionViewLayoutForCurrentBounds()
    }

    private func setCollectionViewLayoutForCurrentBounds() {
        guard let datasource = collectionView.dataSource,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            contentView.bounds.width > 0 else {
            print(#function + ": Failed to cast layout.")
            return
        }

        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.horizontalSectionPadding, bottom: 0, right: Constants.horizontalSectionPadding)

        let itemWidth = Constants.itemWidth(within: contentView)
        layout.itemSize = CGSize(width: itemWidth, height: Constants.itemHeight)

        let itemCount = datasource.collectionView(collectionView, numberOfItemsInSection: 0)
        collectionViewHeightConstraint.constant = Constants.collectionViewHeight(itemCount: CGFloat(itemCount))
    }
}

extension BrowsingTabsContainerCell {
    enum Constants {
        static let spacing: CGFloat = 12
        static let horizontalSectionPadding: CGFloat = 16
        static let numberOfColumns: CGFloat = 2
        static let itemHeight: CGFloat = 100

        static func numberOfRows(itemCount: CGFloat) -> CGFloat {
            return ceil(itemCount / numberOfColumns)
        }
        static func availableWidth(within container: UIView) -> CGFloat {
            container.bounds.width - (2 * Constants.horizontalSectionPadding) - spacing*(numberOfColumns-1)
        }
        static func itemWidth(within container: UIView) -> CGFloat {
            availableWidth(within: container) / numberOfColumns
        }
        static func collectionViewHeight(itemCount: CGFloat) -> CGFloat {
            let numRows = numberOfRows(itemCount: itemCount)
            return itemHeight * numRows + spacing * (numRows - 1)
        }
    }
}
