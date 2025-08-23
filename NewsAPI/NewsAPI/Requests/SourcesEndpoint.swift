//
//  SourcesEndpoint.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/17/25.
//

import Foundation

public struct SourcesEndpoint: NewsEndpoint {
    public typealias Response = SourcesResponse

    public let restfulEndpoint = Restful(
        version: 2,
        path: "top-headlines/sources",
        httpMethod: .GET
    )

    let category: NewsCategory?
    let language: String?
    let country: String?

    public init(category: NewsCategory?, language: String?, country: String?) {
        self.category = category
        self.language = language
        self.country = country
    }

    public var queryParameters: [String : String?] {
        [
            "country" : country,
            "category" : category?.rawValue,
            "language" : language
        ]
    }
}
