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

    private var mode: SettingMode?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
}

extension FilterListSettingTableViewCell {
    func configure(settingMode: SettingMode, title: String, image: UIImage) {
        filterImageView.layer.cornerRadius = 2
        dimmedView.layer.cornerRadius = 2
        dimmedView.layer.opacity = 0.8
        dimmedView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        checkImageView.isHidden = true

        mode = settingMode

        let isHidden: Bool
        switch settingMode {
        case .edit:
            isHidden = false
        case .delete:
            isHidden = true
        case .move:
            isHidden = true
        }
        lineView.isHidden = isHidden
        filterTitleTextField.isHidden = isHidden
        filterTitleLabel.isHidden = !isHidden
        checkImageView.isHidden = !isHidden

        filterTitleLabel.text = title
        filterTitleTextField.text = title
        filterImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        guard let mode = mode else { return }
        switch mode {
        case .delete:
            if isSelected {
                dimmedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                checkImageView.isHidden = false
            } else {
                dimmedView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
                checkImageView.isHidden = true
            }
        case .edit:
            if isSelected {
                self.mode = .move
            }
        case .move:
            if isSelected {
                filterImageView.layer.cornerRadius = filterImageView.bounds.height / 2
                dimmedView.layer.cornerRadius = filterImageView.bounds.height / 2
                dimmedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//                isSelected.toggle()
            } else {
                filterImageView.layer.cornerRadius = 2
                dimmedView.layer.cornerRadius = 2
                dimmedView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            }
        default:
            break
        }
    }
}
