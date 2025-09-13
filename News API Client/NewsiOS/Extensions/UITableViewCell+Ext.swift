//
//  UITableViewCell+Ext.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

extension UITableViewCell {
    static var errorCell = {
        let errorCell = UITableViewCell()
        var config = errorCell.defaultContentConfiguration()
        config.text = "Error loading content."
        errorCell.contentConfiguration = config
        return errorCell
    }()
}
