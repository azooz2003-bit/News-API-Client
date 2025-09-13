//
//  NewsItemCell.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

protocol NewsItemCellDelegate: AnyObject {
    func didTapFavoriteButton(_ isFavorite: Bool)
}

class NewsItemCell: UITableViewCell {

    static let identifier = "NewsItemCell"

    @IBOutlet var containerView: UIView!

    @IBOutlet var headlineImage: UIImageView!
    var image: UIImage! {
         didSet {
             headlineImage.image = image
         }
     }
    @IBOutlet var headlineImageWidth: NSLayoutConstraint!

    @IBOutlet var titleAuthorColumn: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!


    @IBOutlet var favoriteButton: UIButton!
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorite.toggle() // Toggle favorite status and update image
        delegate?.didTapFavoriteButton(isFavorite)
    }
    private var isFavorite: Bool = false {
        didSet {
            if isFavorite {
                self.favoriteButton.setImage(.heartFilled, for: .normal)
            } else {
                self.favoriteButton.setImage(.heartEmpty, for: .normal)
            }
        }
    }

    weak var delegate: NewsItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAdditionalConfiguration()
    }

    private func setupAdditionalConfiguration() {
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemGray.cgColor
        containerView.layer.cornerRadius = 16
    }

    private func setupImageSizeConstraint() {
        let minWidth = CGFloat(100)
        let maxWidth = contentView.bounds.width * 0.2

        let aspectRatio = image.size.width / image.size.height
        let idealWidth = contentView.bounds.height * aspectRatio

        let selectedWidth = max(min(idealWidth, maxWidth), minWidth)
        headlineImageWidth.constant = selectedWidth
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()

        setupImageSizeConstraint()
    }

    func configure(image: UIImage, title: String, author: String, description: String, isFavorited: Bool = false) {
        self.image = image
        titleLabel.text = title
        authorLabel.text = "By " + author
        descriptionLabel.text = description + "erggyiugeigvbegviwegvfwygvytvyetg"
        self.isFavorite = isFavorited
    }
}
