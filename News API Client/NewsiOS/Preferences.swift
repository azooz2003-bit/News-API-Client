//
//  Preferences.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import Foundation
import UIKit

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
    static var detailPresentationStyle: UIModalPresentationStyle {
        get {
            if let sheetStyle = UIModalPresentationStyle(rawValue: UserDefaults.standard.integer(forKey: "detailPresentationStyle")) {
                return sheetStyle
            } else {
                UserDefaults.standard.set(UIModalPresentationStyle.pageSheet.rawValue, forKey: "detailPresentationStyle")
                return .pageSheet
            }
        } set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "detailPresentationStyle")
        }
    }
    static var presentationMode: PresentationMode {
        get {
            if let modeRaw = UserDefaults.standard.string(forKey: "presentationMode"), let mode = PresentationMode(rawValue: modeRaw) {
                return mode
            } else {
                UserDefaults.standard.set(PresentationMode.push.rawValue, forKey: "presentationMode")
                return .push
            }
        } set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "presentationMode")
        }
    }
}


enum PresentationMode: String, CaseIterable {
    case push, modal, alert, actionSheet

    var asAlertControllerStyle: UIAlertController.Style? {
        switch self {
        case .alert: return .alert
        case .actionSheet: return .actionSheet
        default: return nil
        }
    }
}
