//
//  NewsListViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class TopHeadlinesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Top Headlines"
    }

}
