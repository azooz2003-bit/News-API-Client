//
//  Coordinator.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }

    func start() -> UIViewController?
}

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var navigationController: UINavigationController?

    func start() -> UIViewController? {
        let rootVC = ArticlesListViewController()
        rootVC.delegate = self
        self.navigationController = UINavigationController(rootViewController: rootVC)
        self.navigationController?.delegate = self
        self.navigationController?.modalPresentationStyle = .popover
        self.navigationController?.setToolbarHidden(false, animated: false)
        return navigationController
    }

    enum ViewControllerPresentationStyle {
        case push, alert
    }
}

// MARK: Article Presentation

extension MainCoordinator {
    func showArticle(_ article: ArticleItem, as presentationStyle: ViewControllerPresentationStyle = .push) {
        switch presentationStyle {
        case .alert:
            let alert = UIAlertController(title: article.title, message: article.description, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            navigationController?.present(alert, animated: true)
        case .push:
            let detailVC = ArticleDetailViewController()
            detailVC.article = article
            detailVC.delegate = self
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    func showDescription(_ description: String?) {
        let vc = DescriptionViewController(description)
        navigationController?.present(vc, animated: true)
    }
}

// MARK: URL Presentation

extension MainCoordinator {
    func showURL(_ url: URL) {
        let safariVC = URLViewController(url: url)
        navigationController?.present(safariVC, animated: true)
    }
}
