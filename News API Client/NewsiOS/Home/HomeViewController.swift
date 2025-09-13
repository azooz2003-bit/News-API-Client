//
//  HomeViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit

class HomeViewController: UITableViewController {
    var browsingTabs: [BrowsingTab] {
        [.topHeadlines, .apple]
    }
    var favoritesList: [String] {
        ["sample 1", "sample 2", "sample 3"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        navigationItem.title = "News"

        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        navigationItem.standardAppearance = appearance

        // TODO: REMOVE
        navigationItem.style = .browser
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(exampleAction)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(exampleAction))
        ]
    }

    @objc
    func exampleAction() {
        print("TEST")
    }

    private func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.register(BrowsingTabsContainerCell.self, forCellReuseIdentifier: BrowsingTabsContainerCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // TODO: switch to custom news item cell
    }
}

// MARK: Container Table View

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Single cell containing collection view of browsing tabs
        case 1:
            return favoritesList.count // TODO: change to count in actual favorites list
        default:
            preconditionFailure("Table view section count should never exceed 2.")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: BrowsingTabsContainerCell.identifier, for: indexPath) as? BrowsingTabsContainerCell
                cell?.setCollectionViewDataSourceDelegate(self)
                return cell
            case 1:
                // TODO: use row from favorites[indexpath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell?.textLabel?.text = favoritesList[indexPath.row]
                return cell
            default:
                preconditionFailure("Table view section count should never exceed 2.")
            }
        }()

        guard let cell else {
            return UITableViewCell.errorCell
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil // No header for browsing tabs section
        case 1:
            return "Favorites"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            // Browsing tabs section - ignore selection
            break
        case 1:
            // Handle favorites selection
            // TODO: Navigate to news detail or news list
            break
        default:
            break
        }
    }
}

// MARK: Browsing Tabs Collection

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        browsingTabs.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowsingTabCell.identifier, for: indexPath) as! BrowsingTabCell
        cell.browsingTab = browsingTabs[indexPath.row]
        // TODO: configure cell
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        navigationController?.pushViewController(HomeViewController(), animated: true)
        print("Selected item at index \(indexPath)")
    }
}

#Preview {
    let homeVC = HomeViewController()
    let vc = UINavigationController(rootViewController: homeVC)

    homeVC.view.backgroundColor = .systemBackground

    return vc
}
