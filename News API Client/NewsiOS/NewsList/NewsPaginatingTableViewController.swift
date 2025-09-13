//
//  PaginatingTableViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

protocol NewsPaginatingTableViewControllerDelegate: AnyObject {
    func didReachEndOfPage()
}

class NewsPaginatingTableViewController: UITableViewController {
    weak var delegate: NewsPaginatingTableViewControllerDelegate!

    // TODO: change to [NewsItem]
    var newsItems: [String] = [
        "Alex's Mission",
        "Alex's Mission",
        "Alex's Mission",
        "Alex's Mission"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    private func setupTableView() {
        tableView.rowHeight = 100
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
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
//            delegate.didReachEndOfPage()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: push detailVC instead
        navigationController?.pushViewController(HomeViewController(), animated: true)
    }
}

// MARK: UITableViewDataSource

extension NewsPaginatingTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemCell.identifier, for: indexPath) as! NewsItemCell

        let item = newsItems[indexPath.row]
        cell.configure(image: .checkmark, title: item, author: item, description: item)

        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            preconditionFailure("Only one section must exist in pagination table.")
        }

        return newsItems.count
    }
}

#Preview {
    class Sample: NewsPaginatingTableViewControllerDelegate {
        func didReachEndOfPage() {
            print("End of page reached")
        }
    }

    let contentVC = NewsPaginatingTableViewController()
    let sample = Sample()
    contentVC.delegate = sample
    let vc = UINavigationController(rootViewController: contentVC)

    return vc
}
