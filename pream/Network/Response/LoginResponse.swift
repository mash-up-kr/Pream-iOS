//
//  LoginResponse.swift
//  pream
//
//  Created by Gaon Kim on 02/03/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    struct Result: Codable {
        let nickname: String
    }

    let statusCode: Int
    let message: String
    let result: Result
}
