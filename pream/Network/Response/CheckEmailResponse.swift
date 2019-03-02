//
//  CheckEmailResponse.swift
//  pream
//
//  Created by Gaon Kim on 02/03/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

struct CheckEmailResponse: Codable {
    struct Result: Codable {
        let authNumber: String
    }

    let message: String
    let result: Result
    let statusCode: Int
}
