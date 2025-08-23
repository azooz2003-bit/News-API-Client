//
//  NewsEndpoint.swift
//  AppKit1
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

public protocol NewsEndpoint {
    var restfulEndpoint: Restful { get }
    var queryParameters: [String : String?] { get }
    associatedtype Response: Decodable
}

extension NewsEndpoint {
    var queryItems: [URLQueryItem] {
        queryParameters.compactMap { (key, value) in
            guard let value else { return nil }
            return URLQueryItem(name: key, value: value.description)
        }  + [URLQueryItem(name: "apiKey", value: Constants.apiKey)]
    }

    @concurrent
    func call() async throws -> Response {
        let url = try restfulEndpoint.url

        var request = URLRequest(url: url.appending(queryItems: queryItems))
        request.httpMethod = restfulEndpoint.httpMethod.rawValue
        request.setValue(Constants.apiKey, forHTTPHeaderField: "X-Api-Key")
        // TODO: add request headers for POST when needed

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NewsAPIError.missingHTTPResponse
        }
        guard let status = httpResponse.status else {
            throw NewsAPIError.unknownStatusCode
        }
        guard status.responseType == .success else {
            APILogger.log("Request failed with status code: \(status)\n Response: \(httpResponse)")
            throw NewsAPIError.badStatusCode(status)
        }

        return try JSONDecoder.shared.decode(Response.self, from: data)
    }

    public var response: Response {
        get async throws {
            try await call()
        }
    }
    
}
