//
//  GridTab.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/11/25.
//

import Cocoa

enum GridTab {
    case topHeadlines
    case apple

    var title: String {
        switch self {
        case .topHeadlines:
            return "Top Headlines"
        case .apple:
            return "Apple"
        }
    }

    var symbol: NSImage? {
        switch self {
        case .topHeadlines:
            .home
        case .apple:
            .apple
        }
    }

    var tintColor: NSColor {
        switch self {
        case .topHeadlines:
            .systemCyan
        case .apple:
            .systemRed
        }
    }
}
