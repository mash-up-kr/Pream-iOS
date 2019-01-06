//
//  RoundButton.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = bounds.height / 2
    }
}
