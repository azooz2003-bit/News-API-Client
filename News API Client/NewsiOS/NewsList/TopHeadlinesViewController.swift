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
    var activityIndicator: UIActivityIndicatorView!
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
        navigationItem.hidesSearchBarWhenScrolling = false

        activityIndicator = UIActivityIndicatorView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem?.hidesSharedBackground = true
        }
        self.toolbarItems = []

        viewModel.isLoadingPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoadingPage in
                if isLoadingPage {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    @objc private func refresh() {
        print("Refreshing...")
        viewModel.refreshArticles()
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Articles"
        searchController.automaticallyShowsCancelButton = true

        navigationItem.searchController = searchController

        searchTerm
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] searchTerm in
                print("Querying for new search term ...")
                self?.viewModel.refreshArticles(keyword: searchTerm)
            }
            .store(in: &cancellables)
    }

    private func setupPaginatingTableView() {
        self.tableVC = NewsPaginatingTableViewController(delegate: self, newsItemDelegate: self, articles: viewModel.articles.toReadOnlyCurrentValuePublisher())

        self.addChild(tableVC)
        view.addSubview(tableVC.tableView)
        tableVC.didMove(toParent: self)

        tableVC.tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableVC.tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableVC.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableVC.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableVC.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Refresh control

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Articles ...")

        tableVC.tableView.refreshControl = refreshControl
    }

}

extension TopHeadlinesViewController: NewsPaginatingTableViewControllerDelegate {
    var isLoadingPage: Bool {
        get {
            viewModel.isLoadingPage.value
        }
        set {
            viewModel.isLoadingPage.send(newValue)
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

extension TopHeadlinesViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    func updateSearchResults(for searchController: UISearchController) {
        searchTerm.send(searchController.searchBar.text)
    }
}
