//
//  MyFilterCategoryCollectionViewCell.swift
//  pream
//
//  Created by Suji Kim on 06/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class MyFilterCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryBackgroundImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryDetailLabel: UILabel!
    @IBOutlet weak var numberOfFiltersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBackgroundImageView.layer.cornerRadius = 5
    }

    func config() {
        categoryNameLabel.text = "Restaurant"
        categoryDetailLabel.text = "18.10.29 Used 3245"
        categoryBackgroundImageView.image = UIImage(imageLiteralResourceName: "picachu")
        numberOfFiltersLabel.text = "8 Filter"
    }
}
