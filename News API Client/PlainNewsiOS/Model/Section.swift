//
//  Section.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/18/25.
//


enum Section: Int, Hashable {
    case favorites, other

    var title: String {
        switch self {
        case .favorites:
            "Favorites"
        case .other:
            "Other"
        }
    }
}
