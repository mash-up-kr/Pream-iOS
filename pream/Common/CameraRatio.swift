//
//  CameraRatio.swift
//  pream
//
//  Created by 이재성 on 13/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

enum CameraRatio {
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
            self = .full
        }
    }
}
