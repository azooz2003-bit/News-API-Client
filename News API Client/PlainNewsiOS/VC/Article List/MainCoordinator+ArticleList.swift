//
//  MainCoordinator+ArticleList.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import UIKit

extension MainCoordinator: ArticleListViewControllerDelegate {
    func didSelectArticle(_ article: ArticleItem) {
        self.showArticle(article)
    }
}

