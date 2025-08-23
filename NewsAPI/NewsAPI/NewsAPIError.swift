//
//  NewsAPIError.swift
//  AppKit1
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

public enum NewsAPIError: Error {
    case badURL
    case missingHTTPResponse
    case badStatusCode(HTTPStatusCode)
    case unknownStatusCode
}
