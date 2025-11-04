//
//  DescriptionViewController.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/25/25.
//

import UIKit

class DescriptionViewController: UIViewController {
    var content: String?
    lazy var descriptionView = DescriptionView(title: "Description", content: content)

    init(_ description: String?) {
        super.init(nibName: nil, bundle: nil)
        self.content = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let sheetPresentationController {
            sheetPresentationController.detents = [
                .custom { context in
                    // Return height based on intrinsiz size of content
                    return self.view.systemLayoutSizeFitting(
                        CGSize(width: context.maximumDetentValue, height: UIView.layoutFittingCompressedSize.height),
                        withHorizontalFittingPriority: .required,
                        verticalFittingPriority: .fittingSizeLevel
                    ).height + 40
                }
            ]
        }

        self.view.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false

        descriptionView.pinEdges(to: view)
    }
}
