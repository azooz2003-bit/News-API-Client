//
//  TopHeadlinesEndpoint.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

/// Params `country` and `country` can't be used with `sources`. It's one or the other.
public struct TopHeadlinesEndpoint: NewsEndpoint {
    public typealias Response = TopHeadlinesResponse

    public let restfulEndpoint = Restful(
        version: 2,
        path: "top-headlines",
        httpMethod: .GET
    )

    public init(country: String?, category: NewsCategory?, q: String?, pageSize: Int = 20, page: Int = 1) {
        self.country = country
        self.category = category
        self.sources = nil
        self.q = q
        self.pageSize = pageSize
        self.page = page
    }

    public init(sources: [String]?, q: String?, pageSize: Int = 20, page: Int = 1) {
        self.country = nil
        self.category = nil
        self.sources = sources
        self.q = q
        self.pageSize = pageSize
        self.page = page
    }

    let country: String?
    let category: NewsCategory?
    let sources: [String]?
    let q: String?
    let pageSize: Int
    let page: Int

    public var queryParameters: [String : String?] {
        [
            "country" : country,
            "category": category?.rawValue,
            "sources": sources?.joined(separator: ","),
            "q": q,
            "pageSize": String(pageSize),
            "page": String(page),
        ]
    }
}
