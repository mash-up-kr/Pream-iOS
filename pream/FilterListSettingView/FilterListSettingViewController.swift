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
    private var picachuDummyData: [Picachu] = []
    private var sourceIndexPath: IndexPath?
    private var cellSnapShot: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        picachuDummyData = [Picachu](repeatElement(picachu, count: 20))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
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
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let state = sender.state
        let location = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            cleanup()
            return
        }
        switch state {
        case .began:
            sourceIndexPath = indexPath
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            cellSnapShot = customSnapshotFromView(inputView: cell)
            guard let snapshot = cellSnapShot else { return }
            snapshot.center = cell.center
            snapshot.alpha = 0
            tableView.addSubview(snapshot)
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center.y = location.y
                snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                snapshot.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { _ in
                cell.isHidden = true
            })
        case .changed:
            guard  let snapshot = cellSnapShot else {
                return
            }
            snapshot.center.y = location.y
            guard let sourceIndexPath = self.sourceIndexPath else { return }
            if indexPath != sourceIndexPath {
//                swap(&picachuDummyData[indexPath.row], &picachuDummyData[sourceIndexPath.row])
                let sourceData = picachuDummyData[sourceIndexPath.row]
                picachuDummyData[sourceIndexPath.row] = picachuDummyData[indexPath.row]
                picachuDummyData[indexPath.row] = sourceData
                self.tableView.moveRow(at: sourceIndexPath, to: indexPath)
                self.sourceIndexPath = indexPath
            }
        default:
            guard let cell = self.tableView.cellForRow(at: indexPath) else {
                return
            }
            guard  let snapshot = cellSnapShot else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0
                cell.alpha = 1
            }, completion: { _ in
                self.cleanup()
            })
        }
    }

    func customSnapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }

    func cleanup() {
        sourceIndexPath = nil
        cellSnapShot?.removeFromSuperview()
        cellSnapShot = nil
    }
}

extension FilterListSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picachuDummyData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilterListSettingTableViewCell else { return UITableViewCell() }
        let item = picachuDummyData[indexPath.row]
        cell.configure(settingMode: settingMode, title: item.title, image: item.image)
        cell.filterTitleTextField.delegate = self
        return cell
    }
}

extension FilterListSettingViewController: UITextFieldDelegate {

}
