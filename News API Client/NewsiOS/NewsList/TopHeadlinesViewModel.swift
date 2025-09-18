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
    var isLoadingPage: CurrentValueSubject<Bool, Never> = .init(false)
    var fetchingTask: Task<Void, Never>?

    // TODO: make sure no more than one fetch occurs at once.

    private func topHeadlines(forPage page: Int = 1, keyword: String?) async -> [Article] {
        guard !Task.isCancelled else { return [] }

        self.isLoadingPage.send(true)
        defer { self.isLoadingPage.send(false) }

        let request = TopHeadlinesEndpoint(country: "us", category: nil, q: keyword, pageSize: pageSize, page: page)

        do {
            if Preferences.shouldSimulateLongArticlesLoading {
                try await Task.sleep(nanoseconds: 4_000_000_000)
            }

            guard !Preferences.mockDataEnabled else {
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

    func refreshArticles(keyword: String? = nil, onRefreshComplete: (() -> Void)? = nil) {
        fetchingTask?.cancel()
        fetchingTask = Task { [weak self] in
            guard !Task.isCancelled, let self else { return }

            let fetchedArticles = await self.topHeadlines(forPage: 1, keyword: keyword)

            guard !Task.isCancelled else { return }

            self.articles.send(fetchedArticles)
            nextPage = 2
            onRefreshComplete?()
        }
    }
}
