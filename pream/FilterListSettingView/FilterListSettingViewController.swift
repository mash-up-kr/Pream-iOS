//
//  FilterListSettingViewController.swift
//  pream
//
//  Created by Gaon Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

struct Picachu {
    var title: String
    let image: UIImage
}

class FilterListSettingViewController: KeyboardViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    private let cellIdentifier = "filterListSetting"
    private var settingMode: SettingMode = .edit
    private let picachu = Picachu(title: "Picachu", image: #imageLiteral(resourceName: "picachu"))
    private var picachuDummyData: [Picachu] = []
    private var sourceIndexPath: IndexPath?
    private var cellSnapshot: UIView?
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        tableView.showsVerticalScrollIndicator = false
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

        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            let sortedIndexPaths = selectedIndexPaths.sorted { $0.row > $1.row }
            for indexPath in sortedIndexPaths {
                picachuDummyData.remove(at: indexPath.row)
            }
        }

        tableView.reloadData()
    }

    override func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }

    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 10, right: 0)
            var croppedFrame = view.frame
            croppedFrame.size.height -= keyboardSize.height

            guard let activeField = activeField else { return }
            if !croppedFrame.contains(activeField.frame.origin) {
                tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
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
            guard let cell = tableView.cellForRow(at: indexPath) as? FilterListSettingTableViewCell else { return }
            cell.filterImageView.layer.cornerRadius = cell.filterImageView.bounds.height / 2
            cell.dimmedView.layer.cornerRadius = cell.dimmedView.bounds.height / 2
            cell.dimmedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cellSnapshot = customSnapshotFromView(inputView: cell)
            guard let snapshot = cellSnapshot else { return }
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
            guard  let snapshot = cellSnapshot else {
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
            guard let cell = self.tableView.cellForRow(at: indexPath) as? FilterListSettingTableViewCell else {
                return
            }
            guard  let snapshot = cellSnapshot else {
                return
            }
            cell.isHidden = false
            cell.filterImageView.cornerRadius = 2
            cell.dimmedView.layer.cornerRadius = 2
            cell.dimmedView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
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
//        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
//        snapshot.layer.shadowRadius = 5
//        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }

    func cleanup() {
        sourceIndexPath = nil
        cellSnapshot?.removeFromSuperview()
        cellSnapshot = nil
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        guard let cell = textField.superview?.superview as? FilterListSettingTableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let text = textField.text else { return }
        cell.filterTitleLabel.text = text
        picachuDummyData[indexPath.row].title = text
    }
}
