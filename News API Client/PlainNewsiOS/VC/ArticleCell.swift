//
//  ArticleCell.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import UIKit

class ArticleCell: UITableViewCell {
    static let identifier = String(describing: ArticleCell.self)

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!

    @IBAction func onFavoriteTap(_ sender: UIButton) {
        delegate?.favoriteButtonTapped(self, article: article)
    }

    var article: ArticleItem!
    weak var delegate: ArticleCellDelegate?

    override class func awakeFromNib() { super.awakeFromNib() }

    func configure(withArticle article: ArticleItem, delegate: (any ArticleCellDelegate)?) {
        self.article = article
        self.delegate = delegate
        titleLabel.text = article.title
        authorLabel.text = article.author ?? "Unknown"
        updateButtonStyle()
    }

    func updateButtonStyle() {
        favoriteButton.setImage(
            UIImage(systemName: article.isFavorite ? "heart.fill" : "heart"),
            for: .normal
        )
    }
}

protocol ArticleCellDelegate: AnyObject {
    func favoriteButtonTapped(_ cell: ArticleCell, article: ArticleItem)
}
