//
//  TopHeadlinesResponse.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

public struct TopHeadlinesResponse: Decodable, PaginationResulting {
    public let status: ResultStatus
    public let totalResults: Int
    public let articles: [Article]

    public init(status: ResultStatus, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

public struct Article: Codable, Identifiable, Equatable {
    public var id: URL { url }
    public struct Source: Decodable {
        public let id: String?
        public let name: String
    }

    public let author: String?
    public let title: String
    public let description: String?
    public let url: URL
    public let urlToImage: URL?
    public let publishedAt: Date?
    public let content: String?
}
