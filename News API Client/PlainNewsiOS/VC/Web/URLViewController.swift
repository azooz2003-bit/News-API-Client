//
//  URLViewController.swift
//  PlainNewsiOS
//
//  Created by Abdulaziz Albahar on 9/22/25.
//

import UIKit
import WebKit

class URLViewController: UIViewController {

    var toolbar: UIToolbar!
    var webView: WKWebView!

    var url: URL

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTopToolbar()
        setupWebView()
    }

    private func setupTopToolbar() {
        toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil),
            .flexibleSpace(),
            UIBarButtonItem(title: url.absoluteString, image: nil, target: nil, action: nil),
            .flexibleSpace(),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        ]

        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        view.addSubview(toolbar)
    }

    private func setupWebView() {
        self.webView = WKWebView()
        webView.load(URLRequest(url: url))

        self.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 15),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
