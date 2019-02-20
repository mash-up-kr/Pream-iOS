//
//  ShotTimer.swift
//  pream
//
//  Created by jarvis on 20/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

enum ShotTimer: RotateButton {
    case zero
    case three
    case five
    case ten

    mutating func next() {
        switch self {
        case .zero:
            self = .three
        case .three:
            self = .five
        case .five:
            self = .ten
        case .ten:
            self = .zero
        }
    }

    func getImageName() -> String {
        switch self {
        case .zero:
            return "icTimer"
        case .three:
            return "icTimer3"
        case .five:
            return "icTimer5"
        case .ten:
            return "icTimer10"
        }
    }

    func getSeconds() -> Int {
        switch self {
        case .zero:
            return 0
        case .three:
            return 3
        case .five:
            return 5
        case .ten:
            return 10
        }
    }
}
