//
//  UITextField+ActivateButton.swift
//  pream
//
//  Created by Gaon Kim on 03/03/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

extension UITextField {
    func activateButtonIfNotEmpty(button: UIButton) {
        if hasText {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
}
