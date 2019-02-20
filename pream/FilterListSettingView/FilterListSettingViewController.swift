//
//  FilterListSettingViewController.swift
//  pream
//
//  Created by Gaon Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

struct Picachu {
    let title: String
    let image: UIImage
}

class FilterListSettingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    private let cellIdentifier = "filterListSetting"
    private var settingMode: SettingMode = .edit
    private let picachu = Picachu(title: "Picachu", image: #imageLiteral(resourceName: "picachu"))
    private var picachuDummies: [Picachu] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        picachuDummies = [Picachu](repeatElement(picachu, count: 20))
    }

    @IBAction func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func trashButtonAction() {
        settingMode = .delete
        trashButton.isHidden = true
        okButton.isHidden = false
        tableView.reloadData()
    }

    @IBAction func okButtonAction() {
        settingMode = .edit
        trashButton.isHidden = false
        okButton.isHidden = true
        tableView.reloadData()
    }
}

private extension FilterListSettingViewController {

}

extension FilterListSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picachuDummies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterListSettingTableViewCell else { return UITableViewCell() }
        let item = picachuDummies[indexPath.row]
        cell.configure(settingMode: settingMode, title: item.title, image: item.image)
        cell.filterTitleTextField.delegate = self
        return cell
    }
}

extension FilterListSettingViewController: UITextFieldDelegate {

}
