//
//  HomeViewController.swift
//  NewsiOS
//
//  Created by Abdulaziz Albahar on 9/12/25.
//

import UIKit
import NewsAPI

class HomeViewController: UITableViewController {
    var browsingTabs: [BrowsingTab] {
        [.topHeadlines, .apple, .apple, .topHeadlines]
    }
    var moreButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupPrefMenu()
        setupTableView()
    }

    private func setupNavigationBar() {
        navigationItem.title = "News"

        navigationItem.style = .browser
        navigationItem.standardAppearance = UINavigationBarAppearance()
        navigationItem.standardAppearance?.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        moreButton = UIBarButtonItem(image: .ellipsis, menu: UIMenu())
        navigationItem.rightBarButtonItems = [
            moreButton,
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        ]
    }

    private func setupPrefMenu() {
        let menu = UIMenu(image: .ellipsis, options: [], children: [
            UIAction(title: "Enable mock data", image: Preferences.mockDataEnabled ? .checkmark : nil, handler: { [weak self] action in
                Preferences.mockDataEnabled.toggle()
                self?.setupPrefMenu()
            }),
            UIAction(title: "Simulate long image loading", image: Preferences.shouldSimulateLongImageLoadTime ? .checkmark : nil, handler: { [weak self] action in
                Preferences.shouldSimulateLongImageLoadTime.toggle()
                self?.setupPrefMenu()
            }),
            UIAction(title: "Simulate long articles loading", image: Preferences.shouldSimulateLongArticlesLoading ? .checkmark : nil, handler: { [weak self] action in
                Preferences.shouldSimulateLongArticlesLoading.toggle()
                self?.setupPrefMenu()
            }),
        ])

        self.moreButton.menu = menu
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @objc
    func reload() {
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
        spacerView.backgroundColor = .clear
        tableView.tableHeaderView = spacerView

        tableView.register(BrowsingTabsContainerCell.self, forCellReuseIdentifier: BrowsingTabsContainerCell.identifier)
        tableView.register(UINib(nibName: NewsItemCell.identifier, bundle: nil), forCellReuseIdentifier: NewsItemCell.identifier)
    }
}

// MARK: Container Table View

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Single cell containing collection view of browsing tabs
        case 1:
            return UserDefaults.favoriteArticles.count // TODO: change to count in actual favorites list
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
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemCell.identifier) as? NewsItemCell
                cell?.configure(article: UserDefaults.favoriteArticles[indexPath.row], delegate: self)
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
            // TODO: Navigate to news detail
            let detailVC = ArticleDetailViewController(article: UserDefaults.favoriteArticles[indexPath.row], delegate: self)
            navigationController?.pushViewController(detailVC, animated: true)
            break
        default:
            break
        }
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
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
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(TopHeadlinesViewController(), animated: true)
        case 1:
            navigationController?.pushViewController(AppleNewsViewController(), animated: true)
        default:
            break
        }
        print("Selected item at index \(indexPath)")
    }
}

extension HomeViewController: NewsItemDelegate {
    func isFavorite(_ article: Article) -> Bool {
        UserDefaults.favoriteArticles.contains(where: { $0.id == article.id })
    }
    func favoritedIsSet(_ isFavorite: Bool, for article: Article) {

        if isFavorite {
            UserDefaults.favoriteArticles.append(article)
        } else {
            UserDefaults.favoriteArticles.removeAll { $0.id == article.id }
        }

        tableView.reloadData()
    }
}

#Preview {
    let homeVC = HomeViewController()
    UserDefaults.favoriteArticles = Article.preview
    let vc = UINavigationController(rootViewController: homeVC)

    return vc
}
