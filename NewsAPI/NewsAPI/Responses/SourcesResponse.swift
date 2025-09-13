//
//  SourcesResponse.swift
//  AppKit1
//
//  Created by Abdulaziz Albahar on 8/17/25.
//

import Foundation

public struct SourcesResponse: Decodable {
    public let status: ResultStatus
    public let sources: [Source]

    public init(status: ResultStatus, sources: [Source]) {
        self.status = status
        self.sources = sources
    }
}

public struct Source: Decodable {
    public let id: String
    public let name: String
    public let description: String
    public let url: URL
    public let category: NewsCategory
    public let language: String
    public let country: String
}
