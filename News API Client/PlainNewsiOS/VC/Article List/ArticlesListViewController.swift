//
//  ArticlesListViewController.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import UIKit
import Combine

protocol ArticleListViewControllerDelegate: AnyObject {
    func didSelectArticle(_ article: ArticleItem)
}

class ArticlesListViewController: UIViewController {
    var dataSourceController: ArticlesDataSourceController!
    var repository: ArticlesRepository!
    var tableView: UITableView!
    weak var delegate: ArticleListViewControllerDelegate?

    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        repository = ArticlesRepository(articles: ArticleItem.preview)
        setupNavigationBar()
        setupTableView()
        dataSourceController = ArticlesDataSourceController(tableView: tableView, repository: repository)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        repository.articlesSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.dataSourceController.updateSnapshot()
            }
            .store(in: &cancellables)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Plain News"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor : UIColor.systemBlue]

        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.compactAppearance = appearance
    }

    @objc func refresh() {
        repository.articles = ArticleItem.preview
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self

        let spacerView = UIView(frame: .init(x: 0, y: 0, width: 1, height: 40))
        spacerView.backgroundColor = .clear
        tableView.tableHeaderView = spacerView

        tableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ArticlesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = Section(rawValue: indexPath.section)

        let article: ArticleItem = if section == .favorites {
            repository.favArticles[indexPath.row]
        } else { repository.otherArticles[indexPath.row]}

        delegate?.didSelectArticle(article)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // TODO: favorite update
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = Section(rawValue: section)

        let label = UILabel()
        label.text = section?.title

        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleCell else {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil, handler: { [weak self, weak cell] action, view, completionHandler in
            guard let cell else {
                completionHandler(false)
                return
            }

            self?.dataSourceController.favoriteButtonTapped(cell, article: cell.article)
            completionHandler(true)
        })
        action.image = UIImage(systemName: cell.article.isFavorite ? "heart" : "heart.fill")

        return .init(actions: [action])
    }
}

#Preview {
    UINavigationController(rootViewController: ArticlesListViewController())
}
