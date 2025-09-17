//
//  NewsListViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit
import Combine
import NewsAPI

class TopHeadlinesViewController: UIViewController {
    var tableVC: NewsPaginatingTableViewController!
    var viewModel: TopHeadlinesViewModel

    let searchTerm = PassthroughSubject<String?, Never>()
    var cancellables: Set<AnyCancellable> = []

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
        setupSearchBar()
        setupPaginatingTableView()

        viewModel.refreshArticles()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Top Headlines"

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        ]
    }

    @objc private func refresh() {
        viewModel.refreshArticles()
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Articles"

        navigationItem.searchController = searchController

        searchTerm
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] searchTerm in
                self?.viewModel.refreshArticles(keyword: searchTerm)
            }
            .store(in: &cancellables)
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

extension TopHeadlinesViewController: NewsPaginatingTableViewControllerDelegate {
    var isLoadingPage: Bool {
        get {
            viewModel.isLoadingPage
        }
        set {
            viewModel.isLoadingPage = newValue
        }
    }
    
    func didReachEndOfPage() {
        print("Ending reached")
        self.viewModel.fetchMoreTopHeadlines()
    }
}

extension TopHeadlinesViewController: NewsItemDelegate {
    func isFavorite(_ article: Article) -> Bool {
        UserDefaults.favoriteArticles.contains(where: { $0.id == article.id })
    }

    func favoritedIsSet(_ isFavorite: Bool, for article: Article) {
        if isFavorite {
            UserDefaults.favoriteArticles.append(article)
        } else {
            UserDefaults.favoriteArticles.removeAll { $0.id == article.id }
        }
    }
}

extension TopHeadlinesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("New query")
        searchTerm.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancelled")
        searchTerm.send(nil)
    }
}
