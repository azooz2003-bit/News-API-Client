//
//  TopHeadlinesViewModel.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/14/25.
//

import Combine
import NewsAPI
import Foundation

class TopHeadlinesViewModel {
    let articles = CurrentValueSubject<[Article], Never>([])
    var pageSize = 10
    var nextPage = 1
    var isLoadingPage: Bool = false
    var fetchingTask: Task<Void, Never>?

    // TODO: make sure no more than one fetch occurs at once.

    private func topHeadlines(forPage page: Int = 1, keyword: String?) async -> [Article] {
        guard !Task.isCancelled else { return [] }

        self.isLoadingPage = true
        defer { self.isLoadingPage = false }

        let request = TopHeadlinesEndpoint(country: "us", category: nil, q: keyword, pageSize: pageSize, page: page)

        do {
            guard !Preferences.mockDataEnabled else {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return Article.preview
            }

            let response = try await request.response
            return response.articles
        } catch {
            // TODO: display alert via combine
            print("Top headlines fetch failed: \(error)")
        }

        return []
    }

    func fetchMoreTopHeadlines(keyword: String? = nil) {
        fetchingTask?.cancel()
        fetchingTask = Task { [weak self] in
            guard !Task.isCancelled else { return }

            let fetchedArticles: [Article]
            if let self {
                fetchedArticles = await self.topHeadlines(forPage: self.nextPage, keyword: keyword)
            } else {
                return
            }

            guard !Task.isCancelled else { return }

            if let self {
                self.articles.send(self.articles.value + fetchedArticles)
                nextPage += 1
            }
        }
    }

    func refreshArticles(keyword: String? = nil) {
        fetchingTask?.cancel()
        fetchingTask = Task { [weak self] in
            guard !Task.isCancelled else { return }

            let fetchedArticles: [Article]
            if let self {
                fetchedArticles = await self.topHeadlines(forPage: 1, keyword: keyword)
            } else {
                return
            }

            guard !Task.isCancelled else { return }

            if let self {
                self.articles.send(fetchedArticles)
                nextPage = 2
            }
        }
    }
}
