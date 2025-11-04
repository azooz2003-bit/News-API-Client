//
//  MainCoordinator+ArticleDetail.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import UIKit

extension MainCoordinator: ArticleDetailViewControllerDelegate {
    func didRequestMore(_ article: ArticleItem) {
        self.showURL(article.url)
    }

    func didRequestDescription(_ article: ArticleItem) {
        // TODO: show modal
        self.showDescription(article.description)
    }
}
