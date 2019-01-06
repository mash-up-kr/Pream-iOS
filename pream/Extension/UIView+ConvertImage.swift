//
//  UIView+ConverImage.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
