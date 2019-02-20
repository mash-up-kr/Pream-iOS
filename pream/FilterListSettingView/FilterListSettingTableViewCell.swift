//
//  FilterListSettingTableViewCell.swift
//  pream
//
//  Created by Gaon Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

enum SettingMode {
    case edit
    case delete
    case move
}

class FilterListSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterTitleTextField: UITextField!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension FilterListSettingTableViewCell {
    func configure(settingMode: SettingMode, title: String, image: UIImage) {
        filterImageView.layer.cornerRadius = 2
        dimmedView.layer.cornerRadius = 2
        dimmedView.layer.opacity = 0.8
        dimmedView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        checkImageView.isHidden = true

        let isHidden: Bool
        switch settingMode {
        case .edit:
            isHidden = false
        case .delete, .move:
            isHidden = true
        }
        lineView.isHidden = isHidden
        filterTitleTextField.isHidden = isHidden
        filterTitleLabel.isHidden = !isHidden

        filterTitleLabel.text = title
        filterTitleTextField.text = title
        filterImageView.image = image
    }
}
