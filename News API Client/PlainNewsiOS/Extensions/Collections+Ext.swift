//
//  Collections+Ext.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import Foundation

extension Array where Element: AnyObject {
    mutating func appendUniquely(_ newElement: Element) {
        if !contains(where: { $0 === newElement}) {
            append(newElement)
        }
    }
}
