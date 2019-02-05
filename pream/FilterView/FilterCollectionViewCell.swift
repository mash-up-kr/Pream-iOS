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
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabelBottomConstraint: NSLayoutConstraint!

    func config() {
        filterNameLabel.text = "피카츄"
        filterImageView.image = UIImage(named: "picachu")
    }

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                imageTopConstraint.constant = 0
                imageHeightConstraint.constant = 55
                nameLabelBottomConstraint.constant = 20
                filterNameLabel.textColor = UIColor.white
                dimmedView.isHidden = false
            } else {
                imageTopConstraint.constant = 20
                imageHeightConstraint.constant = 35
                nameLabelBottomConstraint.constant = 11
                filterNameLabel.textColor = UIColor(named: "grey")
                dimmedView.isHidden = true
            }
        }
    }
}
