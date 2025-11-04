//
//  UIDivider.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/24/25.
//

import UIKit

class UIDivider: UIView {
    enum Axis {
        case horizontal
        case vertical
    }

    var axis: Axis = .horizontal {
        didSet {
            updateSizeConstraints()
        }
    }

    var isRounded: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }

    var thickness: CGFloat = 4 {
        didSet {
            updateSizeConstraints()
        }
    }

    // MARK: Constraints
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        updateSizeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if isRounded {
            self.clipsToBounds = true
            self.layer.cornerRadius = min(bounds.height, bounds.width) / 2
        } else {
            self.clipsToBounds = false
            self.layer.cornerRadius = 0
        }
    }

    private func updateSizeConstraints() {
        widthConstraint?.isActive = false
        heightConstraint?.isActive = false

        if axis == .horizontal {
            if heightConstraint == nil {
                heightConstraint = self.heightAnchor.constraint(equalToConstant: thickness)
            } else {
                heightConstraint?.constant = thickness
            }

            heightConstraint?.isActive = true
        } else {
            if widthConstraint == nil {
                widthConstraint = self.widthAnchor.constraint(equalToConstant: thickness)
            } else {
                widthConstraint?.constant = thickness
            }

            widthConstraint?.isActive = true
        }
    }
}

extension UIDivider {
    enum Horizontal {
        static var thinRounded: UIDivider {
            let divider = UIDivider()
            divider.backgroundColor = .label
            divider.axis = .horizontal
            divider.isRounded = true
            divider.thickness = 2
            return divider
        }
    }

    enum Vertical {
        static var thinRounded: UIDivider {
            let divider = UIDivider()
            divider.backgroundColor = .label
            divider.axis = .vertical
            divider.isRounded = true
            divider.thickness = 2
            return divider
        }
    }

}
