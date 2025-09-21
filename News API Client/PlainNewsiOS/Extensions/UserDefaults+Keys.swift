//
//  UserDefaults+Keys.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/18/25.
//

import Foundation
import OSLog

nonisolated
extension UserDefaults {
    enum Key: String {
        case isFavoriteArticle
    }

    func setValue<T: Encodable>(newValue: T, forKey key: Key, withSuffix suffix: String? = nil) {
        guard let data = try? JSONEncoder().encode(newValue) else {
            Logger.general.error("[UserDefaults] Failed to encode value of type \(String(describing: newValue.self)) for key: \(key.rawValue)")
            return
        }

        self.set(data, forKey: key.rawValue + (suffix ?? ""))
    }

    func decodedValue<T: Decodable>(forKey key: Key, withSuffix suffix: String? = nil) -> T? {
        guard let data = self.data(forKey: key.rawValue + (suffix ?? "")) else {
            return nil
        }

        if let value = try? JSONDecoder().decode(T.self, from: data) {
            return value
        } else {
            Logger.general.error("[UserDefaults] Failed to decode value of type \(String(describing: T.self)) for key: \(key.rawValue)")
            return nil
        }
    }

    func decodedValue<T: Codable>(forKey key: Key, withSuffix suffix: String? = nil, orDefault default: T) -> T {
        let value = self.decodedValue(forKey: key, withSuffix: suffix) as T?

        if let value {
            return value
        } else {
            setValue(newValue: `default`, forKey: key, withSuffix: suffix)
            return `default`
        }
    }
}
