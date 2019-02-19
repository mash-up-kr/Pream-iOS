//
//  FilterListSettingViewController.swift
//  pream
//
//  Created by Gaon Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterListSettingViewController: UIViewController {
    private let cellIdentifier = "filterListSetting"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func trashButtonAction() {

    }
}

private extension FilterListSettingViewController {

}

extension FilterListSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterListSettingTableViewCell else { return UITableViewCell() }
        cell.configure(settingMode: .edit, title: "Picachu", image: #imageLiteral(resourceName: "picachu"))
        cell.filterTitleTextField.delegate = self
        return cell
    }
}

extension FilterListSettingViewController: UITextFieldDelegate {
    
}
