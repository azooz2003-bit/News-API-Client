//
//  Preferences.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import Foundation

struct Preferences {
    static var showBrowsingTabLabelBackground: Bool {
        get {
            UserDefaults.standard.bool(forKey: "showBrowsingTabLabelBackground")
        } set {
            UserDefaults.standard.set(newValue, forKey: "showBrowsingTabLabelBackground")
        }
    }
    static var mockDataEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "mockDataEnabled")
        } set {
            UserDefaults.standard.set(newValue, forKey: "mockDataEnabled")
        }
    }
    static var shouldSimulateLongImageLoadTime: Bool {
        get {
            UserDefaults.standard.bool(forKey: "shouldSimulateLongImageLoadTime")
        } set {
            UserDefaults.standard.set(newValue, forKey: "shouldSimulateLongImageLoadTime")
        }
    }
    static var shouldSimulateLongArticlesLoading: Bool {
        get {
            UserDefaults.standard.bool(forKey: "shouldSimulateLongArticlesLoading")
        } set {
            UserDefaults.standard.set(newValue, forKey: "shouldSimulateLongArticlesLoading")
        }
    }
}
