//
//  AppleNewsViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/13/25.
//

import UIKit
import Combine
import NewsAPI

class AppleNewsViewController: UIViewController {
    var tableVC: NewsPaginatingTableViewController!
    var viewModel: TopHeadlinesViewModel

    init() {
        viewModel = TopHeadlinesViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupPaginatingTableView()

        viewModel.refreshArticles(keyword: "apple")
    }

    private func setupNavigationBar() {
        navigationItem.title = "Apple News"

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        ]

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableVC.tableView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        viewModel.refreshArticles(keyword: "apple")
    }

    private func setupPaginatingTableView() {
        self.tableVC = NewsPaginatingTableViewController(delegate: self, newsItemDelegate: self, articles: viewModel.articles.toReadOnlyCurrentValuePublisher())

        self.addChild(tableVC)

        view.addSubview(tableVC.view)

        tableVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            tableVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

}

extension AppleNewsViewController: NewsPaginatingTableViewControllerDelegate {
    var isLoadingPage: Bool {
        get {
            viewModel.isLoadingPage.value
        }
        set {
            viewModel.isLoadingPage.send(newValue)
        }
    }

    func didReachEndOfPage() {
        self.viewModel.fetchMoreTopHeadlines(keyword: "apple")
    }
}

extension AppleNewsViewController: NewsItemDelegate {
    func isFavorite(_ article: Article) -> Bool {
        UserDefaults.favoriteArticles.contains(where: {_ in article.id == article.id})
    }

    func favoritedIsSet(_ isFavorite: Bool, for article: Article) {
        UserDefaults.favoriteArticles.removeAll { $0.id == article.id }

        if isFavorite {
            UserDefaults.favoriteArticles.append(article)
        }
    }
}

