//
//  BrowsingTab.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

enum BrowsingTab {
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

    var symbol: UIImage? {
        switch self {
        case .topHeadlines:
                .home
        case .apple:
                .apple
        }
    }

    var tintColor: UIColor {
        switch self {
        case .topHeadlines:
            return .systemMint
        case .apple:
            return .systemTeal
        }
    }
}
