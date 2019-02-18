//
//  FilterTableViewCell.swift
//  pream
//
//  Created by Gaon Kim on 18/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterTitleView: UILabel!
    @IBOutlet weak var uploadButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.layer.cornerRadius = 2
    }
}
