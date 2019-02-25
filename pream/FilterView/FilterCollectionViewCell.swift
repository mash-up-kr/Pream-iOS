//
//  FilterCollectionViewCell.swift
//  pream
//
//  Created by Suji Kim on 26/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var dimmedView: DimmedView!

    func config() {
        filterNameLabel.text = "피카츄"
        filterImageView.image = UIImage(imageLiteralResourceName: "picachu")
    }

    func firstCellConfig() {
        filterNameLabel.isHidden = true
        dimmedView.isHidden = true
        filterImageView.image = UIImage(imageLiteralResourceName: "icFilterSetting")
        filterImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }

    override var isSelected: Bool {
        didSet {
            if filterImageView.image != UIImage(imageLiteralResourceName: "icFilterSetting") {
                if self.isSelected {
                    filterNameLabel.textColor = .white
                    dimmedView.isHidden = false
                    filterNameLabel.isHidden = false
                } else {
                    filterNameLabel.textColor = UIColor(named: "grey")
                    dimmedView.isHidden = true
                    filterNameLabel.isHidden = true
                }
            }
        }
    }
}
