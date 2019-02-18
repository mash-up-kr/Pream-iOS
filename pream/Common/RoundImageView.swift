//
//  RoundImageView.swift
//  pream
//
//  Created by Gaon Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}
