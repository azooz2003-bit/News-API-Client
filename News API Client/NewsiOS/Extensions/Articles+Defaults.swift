//
//  Articles+Defaults.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/15/25.
//

import Foundation
import NewsAPI

extension [Article] {
    func defaultsEncoded() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension UserDefaults {
    static var favoriteArticles: [Article] {
        get {
            guard let favoritesData = UserDefaults.standard.value(forKey: .favIdentifier) as? Data,
                  let favorites = try? JSONDecoder().decode([Article].self, from: favoritesData) else {
                return []
            }

            return favorites
        } set {
            UserDefaults.standard.setValue(newValue.defaultsEncoded(), forKey: .favIdentifier)
        }
    }
}

extension String {
    fileprivate static let favIdentifier = "favorites"
}
