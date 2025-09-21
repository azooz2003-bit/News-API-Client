//
//  Logger.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import OSLog

nonisolated
extension Logger {
    static let general = {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            let basicLogger = Logger()
            basicLogger.error("[Logger] Failed to get bundle identifier!")
            return basicLogger
        }

        return Logger(subsystem: bundleId, category: "General")
    }()
}

