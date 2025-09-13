//
//  BrowsingTabCell.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class BrowsingTabCell: UICollectionViewCell {
    static let identifier = "BrowsingTabCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        let testLabel = UILabel()
        testLabel.text = "Test"
        testLabel.textAlignment = .center
        testLabel.backgroundColor = .systemBlue

        contentView.addSubview(testLabel)

        testLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            testLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            testLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            testLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
