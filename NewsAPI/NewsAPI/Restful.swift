//
//  Restful.swift
//  AppKit1
//
//  Created by Abdulaziz Albahar on 8/16/25.
//

import Foundation

/**
 Is `Encodable` to allow for easy encoding of container object.
 */
public struct Restful: Encodable {

    // MARK: Inputs
    var version: Int
    /// path/to/resource
    let path: String
    let httpMethod: HTTPMethod

    enum CodingKeys: CodingKey {}

    enum HTTPMethod: String {
        case GET
    }

    // MARK: Computed Properties
    var fullPath: String {
        "v\(version)/\(path)"
    }
    var url: URL {
        get throws(NewsAPIError) {
            guard let url = URL(string: "\(Constants.urlOrigin)\(fullPath)") else {
                throw NewsAPIError.badURL
            }

            return url
        }
    }
}
