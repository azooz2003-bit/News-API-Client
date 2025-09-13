//
//  UIView+Shapes.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class UICircleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        self.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
