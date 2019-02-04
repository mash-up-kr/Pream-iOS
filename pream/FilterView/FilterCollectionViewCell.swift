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
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!

    func config() {
        filterNameLabel.text = "피카츄"
        filterImageView.image = UIImage(named: "picachu")
    }

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                topConstraint.constant = 0
                imageHeight.constant = 55
            } else {
                topConstraint.constant = 20
                imageHeight.constant = 35
            }
        }
    }
}
