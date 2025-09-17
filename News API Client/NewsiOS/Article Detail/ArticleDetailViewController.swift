//
//  ArticleDetailViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/15/25.
//

import UIKit
import NewsAPI
import Combine

class ArticleDetailViewController: UIViewController {

    let article: Article
    weak var delegate: NewsItemDelegate?
    var isFavorite: Bool {
        get {
            self.delegate?.isFavorite(article) ?? false
        } set {
            self.delegate?.favoritedIsSet(newValue, for: article)
            favoriteTBItem.image = isFavorite ? .heartFilled : .heartEmpty
        }
    }

    var scrollView: UIScrollView!
    var contentView: UIView!
    var containerStackView: UIStackView!

    var imageView: UIImageView!
    var dividerView: UIView!

    var titleOverlayContainer: UIView!
    var titleOverlayLabel: UILabel!
    var titleOverlayBoundsObservation: NSKeyValueObservation!

    var secondaryInfoView: UIStackView!
    var authorLabel: UILabel!
    var dateLabel: UILabel!

    var descriptionTextView: UITextView!

    var favoriteTBItem: UIBarButtonItem!

    init(article: Article, delegate: NewsItemDelegate?) {
        self.article = article
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupToolbar()
        setupContainerView()
        setupImageView()
        setupDividerView()
        setupSecondaryInfoView()
        setupDescriptionTextView()
        setupTitleOverlayView()
    }

    @objc
    private func favoriteTapped() {
        self.isFavorite.toggle()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactScrollEdgeAppearance = appearance

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: .rightUpArrow, target: self, action: #selector(openURL))
    }

    private func setupToolbar() {
        favoriteTBItem = UIBarButtonItem(image: isFavorite ? .heartFilled : .heartEmpty, style: .plain, target: self, action: #selector(favoriteTapped))
        favoriteTBItem.tintColor = .systemBlue
        self.setToolbarItems([
            favoriteTBItem
        ], animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }

    private func setupContainerView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.pinEdges(to: view)

        contentView = UIView()
        scrollView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pinEdges(to: scrollView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.spacing = 0
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill

        contentView.addSubview(containerStackView)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.pinEdges(to: contentView)
    }

    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true

        Task { [weak self] in
            try await self?.loadImage()
        }

        containerStackView.addArrangedSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }

    private func setupDividerView() {
        dividerView = UIView()
        dividerView.backgroundColor = .black

        containerStackView.addArrangedSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 5)
        ])

    }

    private func setupSecondaryInfoView() {
        secondaryInfoView = UIStackView()
        secondaryInfoView.axis = .horizontal
        secondaryInfoView.alignment = .center
        secondaryInfoView.distribution = .equalSpacing
        secondaryInfoView.isLayoutMarginsRelativeArrangement = true
        secondaryInfoView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        containerStackView.addArrangedSubview(secondaryInfoView)

        authorLabel = UILabel()
        authorLabel.font = .rounded(ofSize: 16, weight: .medium)
        authorLabel.configure(withIcon: .person, title: (article.author ?? "N/A"))

        secondaryInfoView.addArrangedSubview(authorLabel)

        dateLabel = UILabel()
        dateLabel.font = .rounded(ofSize: 16, weight: .medium)
        dateLabel.configure(withIcon: .time, title: (article.publishedAt?.formatted() ?? "N/A"))

        secondaryInfoView.addArrangedSubview(dateLabel)
    }

    private func setupDescriptionTextView() {
        self.descriptionTextView = UITextView()
        descriptionTextView.attributedText = NSAttributedString(string: article.description ?? "N/A")
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.isEditable = false
        descriptionTextView.textAlignment = .center
        descriptionTextView.textColor = .label
        descriptionTextView.font = .rounded(ofSize: 12, weight: .regular)

        containerStackView.addArrangedSubview(descriptionTextView)
    }


    private func setupTitleOverlayView() {
        self.titleOverlayContainer = UIView()
        titleOverlayContainer.backgroundColor = .white.withAlphaComponent(0.8)
        titleOverlayContainer.clipsToBounds = true
        titleOverlayBoundsObservation = titleOverlayContainer.observe(\.bounds) { [weak self] view, _ in
            self?.titleOverlayContainer.layer.cornerRadius = view.bounds.height * 0.5
        }

        imageView.addSubview(titleOverlayContainer)

        titleOverlayContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleOverlayContainer.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            titleOverlayContainer.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleOverlayContainer.widthAnchor.constraint(equalToConstant: 300),
            titleOverlayContainer.heightAnchor.constraint(equalToConstant: 80)
        ])

        self.titleOverlayLabel = UILabel()
        titleOverlayLabel.text = article.title
        titleOverlayLabel.adjustsFontSizeToFitWidth = true
        titleOverlayLabel.textColor = .label
        titleOverlayLabel.minimumScaleFactor = 0.5
        titleOverlayLabel.numberOfLines = 0
        titleOverlayLabel.textAlignment = .center
        titleOverlayLabel.font = .preferredFont(forTextStyle: .headline)

        titleOverlayContainer.addSubview(titleOverlayLabel)

        titleOverlayLabel.translatesAutoresizingMaskIntoConstraints = false
        titleOverlayLabel.pinEdges(to: titleOverlayContainer.readableContentGuide, byMargin: 4)
    }

    private func loadImage() async throws {
        if let cachedImage = NewsItemCell.cachedImages.object(forKey: article.url.absoluteString as NSString) {
            imageView.image = cachedImage
            return
        }

        guard let imageURL = article.urlToImage else {
            return
        }
        let (data, response) = try await URLSession.shared.data(from: imageURL)

        guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let image = UIImage(data: data) else {
            print("Error occured in \(#function) for Article \(self.article.title, default: "(self not found)")")
            return
        }

        try Task.checkCancellation()

        NewsItemCell.cachedImages.setObject(image, forKey: article.url.absoluteString as NSString)
        imageView.image = image
    }

    @objc private func openURL() {
        UIApplication.shared.open(article.url)
    }

    deinit {
        titleOverlayBoundsObservation.invalidate()
    }
}
