//
//  BlurView.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class BlurView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .black
        layer.opacity = 0.4
    }
}
