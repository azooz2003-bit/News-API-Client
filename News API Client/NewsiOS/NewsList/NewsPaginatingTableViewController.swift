//
//  PaginatingTableViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit
import NewsAPI
import Combine

protocol NewsPaginatingTableViewControllerDelegate: AnyObject {
    var isLoadingPage: Bool { get set }
    func didReachEndOfPage()
}

class NewsPaginatingTableViewController: UITableViewController {
    weak var delegate: NewsPaginatingTableViewControllerDelegate?
    weak var newsItemDelegate: NewsItemDelegate?

    private var articles: ReadOnlyCurrentValuePublisher<[Article], Never>
    private var cancellables: Set<AnyCancellable> = []

    init(delegate: NewsPaginatingTableViewControllerDelegate?, newsItemDelegate: NewsItemDelegate?, articles: ReadOnlyCurrentValuePublisher<[Article], Never>) {
        self.delegate = delegate
        self.newsItemDelegate = newsItemDelegate
        self.articles = articles

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        for cell in tableView.visibleCells {
            if let cell =  cell as? NewsItemCell {
                cell.imageLoadingTask?.cancel()
            }
        }
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: NewsItemCell.identifier, bundle: nil), forCellReuseIdentifier: NewsItemCell.identifier)
    }
}


// MARK: UITableViewDelegate

extension NewsPaginatingTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate else { return }

        let height = scrollView.frame.size.height
        let contentYOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYOffset

        if !delegate.isLoadingPage, distanceFromBottom < height {
            delegate.didReachEndOfPage()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = ArticleDetailViewController(article: self.articles.value[indexPath.row], delegate: newsItemDelegate)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: UITableViewDataSource

extension NewsPaginatingTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemCell.identifier, for: indexPath) as! NewsItemCell

        let item = articles.value[indexPath.row]
        cell.configure(article: item, delegate: newsItemDelegate)

        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            preconditionFailure("Only one section must exist in pagination table.")
        }

        return articles.value.count
    }
}

#Preview {
    class Sample: NewsPaginatingTableViewControllerDelegate {
        var isLoadingPage: Bool = false
        func didReachEndOfPage() {
            print("End of page reached")
        }
    }

    let sample = Sample()
    let contentVC = NewsPaginatingTableViewController(
        delegate: sample,
        newsItemDelegate: nil,
        articles: CurrentValueSubject<[Article], Never>(Article.preview).toReadOnlyCurrentValuePublisher()
    )
    let vc = UINavigationController(rootViewController: contentVC)

    return vc
}
