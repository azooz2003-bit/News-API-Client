//
//  DescriptionView.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/24/25.
//

import UIKit

class DescriptionView: UIView {
    var title: String? {
        didSet {
            sectionTitleLabel.text = title
        }
    }
    var content: String? {
        didSet {
            descriptionLabel.text = content
        }
    }

    private var sectionTitleLabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    private var divider: UIDivider = .Horizontal.thinRounded
    private var descriptionLabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    init(title: String?, content: String?) {
        super.init(frame: .zero)
        self.title = title
        self.content = content
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        sectionTitleLabel.text = title
        self.addSubview(sectionTitleLabel)
        sectionTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sectionTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])

        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 8),
            divider.leadingAnchor.constraint(equalTo: sectionTitleLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor),
        ])

        descriptionLabel.text = content
        self.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: sectionTitleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -14)
        ])
    }
}

#Preview {
    let view = DescriptionView(title: "Description", content: ArticleItem.preview[0].description)

    return view
}
