//
//  JSONDecoder+Default.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

extension JSONDecoder {
    static var shared: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
