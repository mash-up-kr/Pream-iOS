//
//  CameraRatio.swift
//  pream
//
//  Created by 이재성 on 13/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

protocol RotateButton {
    func getImageName() -> String
    mutating func next()
}

enum CameraRatio: Int, RotateButton {
    case full
    case oneone
    case fourthree

    mutating func next() {
        switch self {
        case .full:
            self = .fourthree
        case .fourthree:
            self = .oneone
        case .oneone:
            self = .fourthree
        }
    }

    func getImageName() -> String {
        switch self {
        case .full:
            return "icRatioFull"
        case .oneone:
            return "icRatio11"
        case .fourthree:
            return "icRatio43"
        }
    }
}
