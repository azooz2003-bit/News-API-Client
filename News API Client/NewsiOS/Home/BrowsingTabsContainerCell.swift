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

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(BrowsingTabCell.self, forCellWithReuseIdentifier: BrowsingTabCell.identifier)

        contentView.addSubview(collectionView)

        setupConstraints()
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth((1/Constants.numberOfColumns)), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(Constants.itemHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(Constants.spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.horizontalSectionPadding, bottom: 0, trailing: Constants.horizontalSectionPadding)

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)

        return layout
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
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

        setCollectionViewLayoutForCurrentBounds()

//        collectionView.reloadData() NOTE: data doesn't change anyways
    }

    // MARK: Layout

    private func setCollectionViewLayoutForCurrentBounds() {
        guard let datasource = collectionView.dataSource else {
            print(#function + ": No data source available.")
            return
        }

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
        static func collectionViewHeight(itemCount: CGFloat) -> CGFloat {
            let numRows = numberOfRows(itemCount: itemCount)
            return itemHeight * numRows + spacing * (numRows - 1)
        }
    }
}
