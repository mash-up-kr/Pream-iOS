//
//  UIImage+Crop.swift
//  pream
//
//  Created by 이재성 on 13/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x *= scale
        rect.origin.y *= scale
        rect.size.width *= scale
        rect.size.height *= scale

        guard let imageRef = cgImage?.cropping(to: rect) else { return self }
        let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return image
    }
}
