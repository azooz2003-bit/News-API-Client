//
//  ArticleDetailViewController.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import UIKit
import OSLog

protocol ArticleDetailViewControllerDelegate: AnyObject {
    func didRequestMore(_ article: ArticleItem)
    func didRequestDescription(_ article: ArticleItem)
}

class ArticleDetailViewController: UIViewController {
    var article: ArticleItem!
    weak var delegate: ArticleDetailViewControllerDelegate?
    lazy var contentAttrString: NSAttributedString = {
        guard let content = article?.content else {
            Logger.general.debug("No content found.")
            return NSMutableAttributedString(string: "No content available.")
        }

        let contentAttrString = NSMutableAttributedString(string: content)
        contentAttrString.setAttributes([.foregroundColor : UIColor.label, .font : UIFont.systemFont(ofSize: 16, weight: .regular)], range: NSRange(location: 0, length: contentAttrString.length))
        return contentAttrString
    }()
    lazy var seeMoreAttrString: NSAttributedString = {
        let moreAttrString = NSMutableAttributedString(string: " see more")

        if let image = UIImage(systemName: "arrow.up.right") {
            let attachment = NSTextAttachment(image: image)
            let imageAttr = NSAttributedString(attachment: attachment)
            moreAttrString.append(imageAttr)
        } else {
            Logger.general.debug("Could not find symbol for arrow.up.right.")
        }

        moreAttrString.setAttributes([.foregroundColor : UIColor.systemBlue, .font : UIFont.systemFont(ofSize: 16, weight: .bold)], range: NSRange(location: 0, length: moreAttrString.length))
        return moreAttrString
    }()

    // MARK: Views
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true

        return scrollView
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2

        return imageView
    }()
    lazy var imagePlaceHolderSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .white

        return spinner
    }()
    lazy var infoBoxStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.spacing = 0
        return view
    }()
    lazy var infoRow1: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 0
        return view
    }()
    lazy var infoRow1Content: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .firstBaseline
        view.spacing = 5
        return view
    }()
    lazy var infoRow2: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    lazy var dividerView: UIDivider = .Horizontal.thinRounded
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        textView.isUserInteractionEnabled = true
        textView.textAlignment = .left
        textView.isScrollEnabled = false

        return textView
    }()

    // MARK: Constraints
    var imageWidthConstraint: NSLayoutConstraint?
    var imageHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupToolbar()
        setupScrollView()
        setupImageView()
        setupInfoBox()
        setupDivider()
        setupContentTextView()
        setupContentText()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.loadImage()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Detail"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newImageTapped))
    }

    private func setupToolbar() {
        self.toolbarItems = [
            .flexibleSpace(),
            UIBarButtonItem(image: .Text.rectangle, style: .plain, target: self, action: #selector(textSymbolTapped))
        ]
    }

    @objc
    private func textSymbolTapped() {
        delegate?.didRequestDescription(article)
    }

    @objc
    private func newImageTapped() {
        loadImage()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let frameLayoutGuide = scrollView.frameLayoutGuide
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            frameLayoutGuide.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            frameLayoutGuide.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            frameLayoutGuide.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            frameLayoutGuide.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        let contentLayoutGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentLayoutGuide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
        ])

        // Image sizing

        let sizeLimitConstraints: [NSLayoutConstraint] = [
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
        ]

        NSLayoutConstraint.activate(sizeLimitConstraints)

        self.imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 100)
        self.imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 100)

        NSLayoutConstraint.activate([imageWidthConstraint, imageHeightConstraint].compactMap { $0 })

        // Spinner

        imagePlaceHolderSpinner.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(imagePlaceHolderSpinner)

        NSLayoutConstraint.activate([
            imagePlaceHolderSpinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imagePlaceHolderSpinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

    private func setupInfoBox() {
        infoBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoBoxStackView)

        NSLayoutConstraint.activate([
            infoBoxStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            infoBoxStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoBoxStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])

        infoBoxStackView.addArrangedSubview(infoRow1)

        infoRow1.addArrangedSubview(infoRow1Content)
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        infoRow1.addArrangedSubview(spacerView)

        infoRow1Content.addArrangedSubview(titleLabel)
        infoRow1Content.addArrangedSubview(sourceLabel)

        infoBoxStackView.addArrangedSubview(infoRow2)
        infoRow2.addArrangedSubview(authorLabel)
        infoRow2.addArrangedSubview(UIView())
        infoRow2.addArrangedSubview(dateLabel)

        titleLabel.text = article?.title ?? "No title available"
        sourceLabel.text = "(" + (article?.sourceName ?? "Unknown source") + ")"
        sourceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        authorLabel.text = article?.author ?? "Unknown author"
        dateLabel.text = article?.publishedAt?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown date"
    }

    private func setupDivider() {
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dividerView)

        NSLayoutConstraint.activate([
            dividerView.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor),
            dividerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dividerView.topAnchor.constraint(equalTo: infoBoxStackView.bottomAnchor, constant: 10)
        ])
    }

    private func setupContentTextView() {
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentTextView)

        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            contentTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentTextView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20),
            contentTextView.widthAnchor.constraint(equalTo: contentView.readableContentGuide.widthAnchor)
        ])
    }

    private func setupContentText() {
        let resultingString = NSMutableAttributedString(attributedString: contentAttrString)
        resultingString.append(seeMoreAttrString)

        contentTextView.attributedText = resultingString
        configureSeeMoreGesture()
    }

    private func configureSeeMoreGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextViewTapped))
        contentTextView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc private func handleTextViewTapped(_ gesture: UITapGestureRecognizer) {
        guard let article, gesture.state == .ended else { return }

        let linkStartPos = contentAttrString.string.count
        let linkEndPos = linkStartPos + seeMoreAttrString.length - 1
        let tapLocation = gesture.location(in: contentTextView)

        let textStorage = NSTextStorage(attributedString: contentTextView.attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: contentTextView.bounds.size)
        layoutManager.addTextContainer(textContainer)

        let tappedCharacterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        // We check for < linkEndPos because we do not want taps on spaces after the last character to be recognized
        if tappedCharacterIndex >= linkStartPos && tappedCharacterIndex < linkEndPos {
            delegate?.didRequestMore(article)
        }
    }

    // TODO: animate image scale change
    private func updateImage(_ image: UIImage?) {
        if let image {
            self.imageView.image = image
            NSLayoutConstraint.deactivate([self.imageWidthConstraint, self.imageHeightConstraint].compactMap { $0 })
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }

    private func loadImage() {
        guard let url = article?.urlToImage else { return }

        imageView.image = nil
        imagePlaceHolderSpinner.startAnimating()
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async { [weak self] in
                defer {
                    self?.imagePlaceHolderSpinner.stopAnimating()
                }
                guard let data, let image = UIImage(data: data) else {
                    self?.updateImage(.remove)
                    return
                }

                self?.updateImage(image)
            }
        }

        task.resume()
    }
}

#Preview {
    let coordinator = MainCoordinator()
    let vc = coordinator.start() as! UINavigationController
    coordinator.showArticle(ArticleItem.preview.first!)

    return vc
}
