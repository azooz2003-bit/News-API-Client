//
//  ArticlesDataSourceController.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import UIKit
import Combine
import OSLog

class ArticlesDataSourceController {
    var tableView: UITableView
    var dataSource: UITableViewDiffableDataSource<Section, ArticleItem>!
    var repository: ArticlesRepository

    var cancellables: Set<AnyCancellable> = []

    init(tableView: UITableView, repository: ArticlesRepository) {
        self.tableView = tableView
        self.repository = repository
        self.dataSource = self.createDataSource(for: tableView, withDelegate: self)
        self.tableView.dataSource = dataSource
    }

    private func createDataSource(for tableView: UITableView, withDelegate delegate: ArticleCellDelegate?) -> UITableViewDiffableDataSource<Section, ArticleItem> {
        UITableViewDiffableDataSource<Section, ArticleItem>(tableView: tableView) { (tableView, indexPath, article) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {
                Logger.general.error("[\(ArticlesDataSourceController.self)] Unexpected cell type.")
                return nil
            }

            cell.configure(withArticle: article, delegate: delegate)

            return cell
        }
    }

    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ArticleItem>()

        snapshot.appendSections([.favorites, .other])

        snapshot.appendItems(repository.favArticles, toSection: .favorites)
        snapshot.appendItems(repository.otherArticles, toSection: .other)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ArticlesDataSourceController: ArticleCellDelegate {
    func favoriteButtonTapped(_ cell: ArticleCell, article: ArticleItem) {
        var article = article
        article.isFavorite.toggle()
        cell.updateButtonStyle()

        self.updateSnapshot()
    }
}
