//
//  Article+Preview.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/13/25.
//

import NewsAPI
import Foundation

extension Article {
    static var preview: [Article] {
        if let path = Bundle.main.path(forResource: "articles", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {

            return (try? JSONDecoder.shared.decode([Article].self, from: data)) ?? []
        } else {
            return []
        }
    }
}
