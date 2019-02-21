//
//  FilterSelectCollectionViewCell.swift
//  pream
//
//  Created by JERCY on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

enum Effects: Int, CaseIterable {
    case exposure
    case contrast
    case sharpen
    case saturation
    case highlight
    case shadow
    case whiteBalance
    case vignette
    case grain
    case fade
    case splitTone

    func getImage() -> UIImage {
        switch self {
        case .exposure:
            return UIImage(imageLiteralResourceName: "icExposure")
        case .contrast:
            return UIImage(imageLiteralResourceName: "icContrast")
        case .sharpen:
            return UIImage(imageLiteralResourceName: "icSharpen")
        case .saturation:
            return UIImage(imageLiteralResourceName: "icSaturation")
        case .highlight:
            return UIImage(imageLiteralResourceName: "icHighlight")
        case .shadow:
            return UIImage(imageLiteralResourceName: "icShadow")
        case .whiteBalance:
            return UIImage(imageLiteralResourceName: "icWhiteBalance")
        case .vignette:
            return UIImage(imageLiteralResourceName: "icVignette")
        case .grain:
            return UIImage(imageLiteralResourceName: "icGrain")
        case .fade:
            return UIImage(imageLiteralResourceName: "icFade")
        case .splitTone:
            return UIImage(imageLiteralResourceName: "icSplitTone")
        }
    }

    func getText() -> String {
        switch self {
        case .exposure:
            return "Exposure"
        case .contrast:
            return "Contrast"
        case .sharpen:
            return "Sharpen"
        case .saturation:
            return "Saturation"
        case .highlight:
            return "Highlight"
        case .shadow:
            return "Shadow"
        case .whiteBalance:
            return "White\nBalance"
        case .vignette:
            return "Vignette"
        case .grain:
            return "Grain"
        case .fade:
            return "Fade"
        case .splitTone:
            return "Split\nTone"
        }
    }
}

class FilterSelectCollectionViewCell: UICollectionViewCell {
    var effect: Effects?
    @IBOutlet weak var effectImageView: UIImageView!
    @IBOutlet weak var effectLabel: UILabel!

    func setEffect(_ effect: Effects) {
        self.effect = effect

        effectImageView.image = effect.getImage()
        effectLabel.text = effect.getText()
    }
}
