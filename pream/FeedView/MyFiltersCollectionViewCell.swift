//
//  MyFiltersCollectionViewCell.swift
//  pream
//
//  Created by Gaon Kim on 12/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class MyFiltersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
    }
}
