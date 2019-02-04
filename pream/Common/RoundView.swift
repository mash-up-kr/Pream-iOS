//
//  RoundView.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RoundView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func layoutSubviews() {
        layer.cornerRadius = bounds.height / 2

        super.layoutSubviews()
    }
}
