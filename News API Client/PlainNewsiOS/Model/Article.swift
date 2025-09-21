//
//  Article.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import Foundation
import NewsAPI

nonisolated
struct ArticleItem {
    var id: URL { url }

    let author: String?
    let title: String
    let description: String?
    let url: URL
    let urlToImage: URL?
    let publishedAt: Date?
    let content: String?

    var isFavorite: Bool {
        get {
            UserDefaults.standard.decodedValue(forKey: .isFavoriteArticle, withSuffix: id.absoluteString, orDefault: false)
        }
        set {
            UserDefaults.standard.setValue(newValue: newValue, forKey: .isFavoriteArticle, withSuffix: id.absoluteString)
        }
    }

    init(from article: Article) {
        author = article.author
        title = article.title
        description = article.description
        url = article.url
        urlToImage = article.urlToImage
        publishedAt = article.publishedAt
        content = article.content
    }
}

nonisolated
extension ArticleItem: Hashable, Equatable {
    public static func == (lhs: ArticleItem, rhs: ArticleItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
