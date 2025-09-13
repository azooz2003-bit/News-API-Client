//
//  BrowsingTabCell.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class BrowsingTabCell: UICollectionViewCell {
    static let identifier = "BrowsingTabCell"

    private let containerView = UIView()
    private let circleView = UICircleView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    var browsingTab: BrowsingTab! {
        didSet {
            containerView.backgroundColor = browsingTab.tintColor
            titleLabel.text = browsingTab.title

            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular))
            imageView.image = browsingTab.symbol?.withConfiguration(config)
            imageView.tintColor = browsingTab.tintColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContainer()
        setupTitleLabel()
        setupCircleView()
        setupImageView()
    }

    private func setupContainer() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(circleView)
        containerView.addSubview(imageView)

        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupTitleLabel() {
        self.titleLabel.textColor = .systemBackground
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = .rounded(ofSize: 14, weight: .bold)
        self.titleLabel.numberOfLines = 1

        if Preferences.showBrowsingTabLabelBackground {
            self.titleLabel.backgroundColor = .black
        }

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            self.titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            self.titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            self.titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 4)
        ])
    }

    private func setupCircleView() {
        circleView.backgroundColor = .systemBackground

        circleView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
