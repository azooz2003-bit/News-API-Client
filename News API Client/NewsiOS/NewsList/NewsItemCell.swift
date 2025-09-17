//
//  NewsItemCell.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit
import NewsAPI

protocol NewsItemDelegate: AnyObject {
    func favoritedIsSet(_ isFavorite: Bool, for article: Article)
    func isFavorite(_ article: Article) -> Bool
}

class NewsItemCell: UITableViewCell {

    static let identifier = "NewsItemCell"
    static let cachedImages = NSCache<NSString, UIImage>()

    @IBOutlet var containerView: UIView!

    @IBOutlet var headlineImage: UIImageView!
    @IBOutlet var headlineImageWidth: NSLayoutConstraint!

    @IBOutlet var titleAuthorColumn: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var favoriteButton: UIButton!
    @IBAction func favoriteButtonAction(_ sender: Any) {
        isFavorite.toggle()
    }

    var imagePlaceholder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var imageProgressIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.backgroundColor = .lightGray
        indicatorView.color = .white
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()

    private var article: Article?
    private var isFavorite: Bool {
        get {
            guard let article, let delegate else { return false }

            return delegate.isFavorite(article)
        }
        set {
            guard let article, let delegate else { return }

            delegate.favoritedIsSet(newValue, for: article)
            configureFavoriteButton()
        }
    }
    var imageLoadingTask: Task<Void, Never>?
    weak var delegate: NewsItemDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupContainer()
        setupImagePlaceholder()
        setupLoadingIndicator()
    }

    private func setupContainer() {
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.2).cgColor
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
    }

    private func setupImagePlaceholder() {
        let imageIcon = UIImage(systemName: "photo")
        let imageViewIcon = UIImageView(image: imageIcon)
        imageViewIcon.tintColor = .white
        imageViewIcon.contentMode = .scaleAspectFill

        containerView.addSubview(imagePlaceholder)
        imagePlaceholder.addSubview(imageViewIcon)

        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imagePlaceholder.topAnchor.constraint(equalTo: headlineImage.topAnchor),
            imagePlaceholder.bottomAnchor.constraint(equalTo: headlineImage.bottomAnchor),
            imagePlaceholder.leadingAnchor.constraint(equalTo: headlineImage.leadingAnchor),
            imagePlaceholder.trailingAnchor.constraint(equalTo: headlineImage.trailingAnchor),
            
            imageViewIcon.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            imageViewIcon.centerYAnchor.constraint(equalTo: imagePlaceholder.centerYAnchor),

            imageViewIcon.widthAnchor.constraint(equalToConstant: 30),
            imageViewIcon.heightAnchor.constraint(equalToConstant: 30)
        ])

        containerView.sendSubviewToBack(imagePlaceholder)
    }

    private func setupLoadingIndicator() {
        containerView.addSubview(imageProgressIndicator)
        // Loading indicator rect should be same bounds as image at all times.
        NSLayoutConstraint.activate([
            imageProgressIndicator.topAnchor.constraint(equalTo: headlineImage.topAnchor),
            imageProgressIndicator.bottomAnchor.constraint(equalTo: headlineImage.bottomAnchor),
            imageProgressIndicator.leadingAnchor.constraint(equalTo: headlineImage.leadingAnchor),
            imageProgressIndicator.trailingAnchor.constraint(equalTo: headlineImage.trailingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupImageSizeConstraint()
        setupSelectionBackground()
    }

    private func setupImageSizeConstraint() {
        guard let image = headlineImage.image else { return }

        let minWidth = CGFloat(100)
        let maxWidth = contentView.bounds.width * 0.4

        let aspectRatio = image.size.width / image.size.height
        let idealWidth = contentView.bounds.height * aspectRatio

        let selectedWidth = max(min(idealWidth, maxWidth), minWidth)
        headlineImageWidth.constant = selectedWidth
    }

    private func setupSelectionBackground() {
        if let selectedBackgroundView = selectedBackgroundView {
            selectedBackgroundView.bounds = containerView.bounds
        } else {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .gray.withAlphaComponent(0.2)
            selectedBackgroundView.layer.cornerRadius = self.containerView.layer.cornerRadius
            selectedBackgroundView.bounds = containerView.bounds

            self.selectedBackgroundView = selectedBackgroundView
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        resetImageView()
    }

    private func resetImageView() {
        showImageLoadingIndicator(false)
        headlineImageWidth.constant = 100
        imageLoadingTask?.cancel()
        headlineImage.image = nil
    }

    func configure(article: Article, delegate: NewsItemDelegate?) {
        self.article = article
        self.delegate = delegate

        configureLabels(forArticle: article)
        configureFavoriteButton()
        loadImage()
    }

    private func configureLabels(forArticle article: Article) {
        titleLabel.text = article.title
        authorLabel.text = "By " + (article.author ?? "N/A")
        descriptionLabel.text = article.description ?? "N/A"
    }

    private func configureFavoriteButton() {
        if isFavorite {
            self.favoriteButton.setImage(.heartFilled, for: .normal)
        } else {
            self.favoriteButton.setImage(.heartEmpty, for: .normal)
        }
    }

    private func loadImage() {
        resetImageView() // Redundant atm, but keeping as guardrail for future changes

        if let article, let url = article.urlToImage {
            self.showImageLoadingIndicator(true)

            if let cachedImage = Self.cachedImages.object(forKey: url.absoluteString as NSString) {
                self.setHeadlineImage(cachedImage)
                self.showImageLoadingIndicator(false)
                return
            }

            imageLoadingTask = Task { @MainActor [weak self] in
                defer {
                    // If task was cancelled, it means that the cell is being reconstructed or an image load is being re-done
                    if !Task.isCancelled {
                        self?.showImageLoadingIndicator(false)
                    }
                }

                do {
                    let (data, response) = try await URLSession.shared.data(from: url)

                    if Preferences.shouldSimulateLongImageLoadTime {
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                    }

                    guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let image = UIImage(data: data) else {
                        print("Error occured in \(#function) for Article \(self?.article?.title, default: "(self not found)")")
                        return
                    }

                    try Task.checkCancellation()

                    Self.cachedImages.setObject(image, forKey: url.absoluteString as NSString)
                    self?.setHeadlineImage(image)
                } catch {
                    print("Image loading failed: \(error)")
                }
            }
        } else {
            print("\(#function) No image URL for Article \(article?.title, default: "Unknown")")
        }
    }

    private func setHeadlineImage(_ image: UIImage?) {
        headlineImage.image = image
        self.setNeedsLayout()
    }

    private func showImageLoadingIndicator(_ show: Bool) {
        if show {
            imageProgressIndicator.startAnimating()
            imageProgressIndicator.isHidden = false
        } else {
            imageProgressIndicator.stopAnimating()
            imageProgressIndicator.isHidden = true
        }
    }
}
