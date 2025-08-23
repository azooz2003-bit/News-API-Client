//
//  APILogger.swift
//  NewsAPI
//
//  Created by Abdulaziz Albahar on 8/17/25.
//

import Foundation
import os

struct APILogger {
    private static let logger = Logger()

    static func log(_ message: String) {
        logger.debug("[API Log] \(message)")
    }
}
