//
//  AppleNewsViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/13/25.
//

import UIKit

class AppleNewsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Apple News"
    }
}
