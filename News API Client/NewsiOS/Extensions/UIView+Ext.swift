//
//  UIView+Ext.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/15/25.
//

import UIKit

extension UIView {
    func pinEdges(to view: UIView, byMargin margin: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin)
        ])
    }

    func pinEdges(to guide: UILayoutGuide, byMargin margin: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin),
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin),
            self.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin),
            self.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin)
        ])
    }
}

extension UILabel {
    func configure(withIcon icon: UIImage, title: String) {
        let attrString = NSMutableAttributedString(attachment: NSTextAttachment(image: icon))
        attrString.append(NSAttributedString(string: " " + title))
        self.attributedText = attrString
    }
}
