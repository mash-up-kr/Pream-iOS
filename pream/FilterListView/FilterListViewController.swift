//
//  FilterListViewController.swift
//  pream
//
//  Created by Gaon Kim on 18/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterListViewController: UIViewController {
    @IBOutlet weak var preamFilterView: UIView!
    @IBOutlet weak var tableView: UITableView!

    enum FilterListCell: String, CaseIterable {
        case filterHeader
        case filter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePreamFilterView()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

private extension FilterListViewController {
    func getFilterCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, section: FilterListCell) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath) as? FilterTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.filterImageView.image = #imageLiteral(resourceName: "picachu")
        cell.filterTitleView.text = "피카피카"
        return cell
    }

    func configurePreamFilterView() {
        preamFilterView.layer.masksToBounds = false
        preamFilterView.layer.shadowColor = UIColor.black.cgColor
        preamFilterView.layer.shadowOpacity = 0.3
        preamFilterView.layer.shadowOffset = CGSize.zero
        preamFilterView.layer.shadowRadius = 3
    }
}

extension FilterListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilterListCell.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FilterListCell.allCases[section]
        switch section {
        case .filterHeader:
            return 1
        case .filter:
            return 20
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FilterListCell.allCases[indexPath.section]
        let cell: UITableViewCell

        switch section {
        case .filterHeader:
            cell = tableView.dequeueReusableCell(withIdentifier: section.rawValue, for: indexPath)
        case .filter:
            cell = getFilterCell(tableView, cellForRowAt: indexPath, section: section)
        }

        return cell
    }
}

extension FilterListViewController: UITableViewDelegate {

}

extension FilterListViewController: FilterTableViewCellDelegate {
    func filterTableViewCell(_ sender: FilterTableViewCell, viewControllerToPresent: TextInputDimedViewController) {
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
