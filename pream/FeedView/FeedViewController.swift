//
//  FeedViewController.swift
//  pream
//
//  Created by Gaon Kim on 06/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

enum Feed: String, CaseIterable {
    case userFiltersHeader
    case userFilters
}

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Extension
private extension FeedViewController {
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
        case .userFiltersHeader:
            return 1
        case .userFilters:
            return 5
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Feed.allCases[indexPath.section]
        let cell: UITableViewCell

        switch section {
        case .userFiltersHeader:
            cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue) ?? UITableViewCell()
        case .userFilters:
            cell = getUserFiltersCell(tableView, cellForRowAt: indexPath, section: section)
        }

        return cell
    }
}

extension FeedViewController: UITableViewDelegate {

}
