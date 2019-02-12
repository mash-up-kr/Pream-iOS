//
//  FeedViewController.swift
//  pream
//
//  Created by Gaon Kim on 06/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

enum Feed: String, CaseIterable {
    case myFiltersHeader
    case myFilters
    case userFiltersHeader
    case userFilters
}

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let myFiltersCollectionIdentifier = "myFiltersCollection"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Extension
private extension FeedViewController {
    func getMyFiltersCell(_ tableView: UITableView, section: Feed) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue) as? MyFiltersTableViewCell else { return UITableViewCell() }
        cell.collectionView.dataSource = self
        return cell
    }

    func getUserFiltersCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: Feed) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? UserFiltersTableViewCell else { return UITableViewCell() }
        cell.filterImageView.image = #imageLiteral(resourceName: "picachu")
        cell.nameLabel.text = "피카츄"
        cell.descriptionLabel.text = "피카츄는 짱 귀엽다구!"
        return cell
    }
}

// MARK: - Table View Data Source
extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Feed.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Feed.allCases[section]
        switch section {
        case .myFiltersHeader, .userFiltersHeader, .myFilters:
            return 1
        case .userFilters:
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Feed.allCases[indexPath.section]
        let cell: UITableViewCell

        switch section {
        case .myFiltersHeader, .userFiltersHeader:
            cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue) ?? UITableViewCell()
        case .myFilters:
            cell = getMyFiltersCell(tableView, section: section)
        case .userFilters:
            cell = getUserFiltersCell(tableView, cellForRowAt: indexPath, section: section)
        }

        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = Feed.allCases[indexPath.section]
        if section == .myFilters {
            return 152
        } else {
            return UITableView.automaticDimension
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myFiltersCollectionIdentifier, for: indexPath) as? MyFiltersCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = #imageLiteral(resourceName: "picachu.png")
        cell.titleLabel.text = "피카피카"
        return cell
    }
}
