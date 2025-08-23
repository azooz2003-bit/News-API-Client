//
//  NewsAPITests.swift
//  NewsAPITests
//
//  Created by Abdulaziz Albahar on 8/22/25.
//

import Testing
import NewsAPI

struct NewsAPITests {

    @Test func simpleTopHeadlinesTest() async throws {
        let endpoint = TopHeadlinesEndpoint(country: "us", category: nil, q: nil)
        let topHeadlines = try await endpoint.response
        
        #expect(topHeadlines.status == .ok)
        #expect(topHeadlines.totalResults > 0)

        print("Top Headlines:\n\(topHeadlines.articles)")
    }

}
