//
//  UIView+FindViewController.swift
//  pream
//
//  Created by 이재성 on 26/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
