//
//  UserFiltersTableViewCell.swift
//  pream
//
//  Created by Gaon Kim on 07/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class UserFiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.layer.cornerRadius = 2
    }
}
