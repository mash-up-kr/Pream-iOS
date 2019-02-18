//
//  DimmedView.swift
//  pream
//
//  Created by Suji Kim on 04/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class DimmedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .black
        layer.opacity = 0.5
        layer.cornerRadius = 2
//        layer.borderWidth = 1.5
//        layer.borderColor = UIColor.white.cgColor
    }
}
