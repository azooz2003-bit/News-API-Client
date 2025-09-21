//
//  ArticlesRepository.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import Combine

class ArticlesRepository {
    var articles: [ArticleItem] {
        set {
            articlesSubject.send(newValue)
        } get {
            articlesSubject.value
        }
    }

    var favArticles: [ArticleItem] {
        articles.filter { $0.isFavorite }
    }

    var otherArticles: [ArticleItem] {
        articles.filter { !$0.isFavorite }
    }

    var articlesSubject: CurrentValueSubject<[ArticleItem], Never>

    init(articles: [ArticleItem] = []) {
        self.articlesSubject = CurrentValueSubject(articles)
    }
}
