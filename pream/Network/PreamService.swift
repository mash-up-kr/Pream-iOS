//
//  PreamService.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation
import Moya
//참고: https://github.com/Moya/Moya/blob/master/docs/Examples/Basic.md
enum PreamService {
    case login(email: String, password: String)
}

extension PreamService: TargetType {
    var sampleData: Data { return Data() }
    var baseURL: URL { return URL(string: "http://ec2-13-124-136-88.ap-northeast-2.compute.amazonaws.com:9000")! }
    var path: String {
        switch self {
        case .login:
            return "/api/v1/user/login"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
