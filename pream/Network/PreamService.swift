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
    case signupCheckEmail(email: String)
    case signupCheckNickname(nickname: String)
    case signupSave(email: String, nickname: String, password: String)
    case getMyFilter(id: Int)
    case createMyFilter(adjust: Float,
                        clarity: Float,
                        colorFilter: Float,
                        contrast: Float,
                        exposure: Float,
                        fade: Float,
                        grain: Float,
                        id: Int,
                        name: String,
                        saturation: Float,
                        sharpen: Float,
                        splitTone: Float,
                        tone: Float,
                        vignette: Float,
                        whiteBalance: Float)
    case getMyFilterList
    case updateMyFilter(adjust: Float,
                        clarity: Float,
                        colorFilter: Float,
                        contrast: Float,
                        exposure: Float,
                        fade: Float,
                        grain: Float,
                        id: Int,
                        name: String,
                        saturation: Float,
                        sharpen: Float,
                        splitTone: Float,
                        tone: Float,
                        vignette: Float,
                        whiteBalance: Float)
}

extension PreamService: TargetType {
    var sampleData: Data { return Data() }
    var baseURL: URL { return URL(string: "http://ec2-13-124-136-88.ap-northeast-2.compute.amazonaws.com:9000")! }
    var path: String {
        switch self {
        case .login:
            return "/api/v1/user/login"
        case .signupCheckEmail(let email):
            return "/api/v1/user/signup/check/email/\(email)"
        case .signupCheckNickname(let nickname):
            return "/api/v1/user/signup/check/nickname/\(nickname)"
        case .signupSave:
            return "/api/v1/user/signup/save"
        case .getMyFilter(let id):
            return "/api/v1/myfilter/\(id)"
        case .createMyFilter:
            return "/api/v1/myfilter"
        case .getMyFilterList:
            return "/api/v1/myfilter"
        case .updateMyFilter(let name):
            return "/api/v1/myfilter/\(name)"
        }
    }
    var method: Moya.Method {
        switch self {
        case .login, .signupCheckEmail, .signupCheckNickname, .signupSave, .createMyFilter:
            return .post
        case .getMyFilter, .getMyFilterList:
            return .get
        case .updateMyFilter:
            return .put
        }
    }
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .signupCheckEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .signupCheckNickname(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: JSONEncoding.default)
        case .signupSave(let email, let nickname, let password):
            return .requestParameters(parameters: ["email": email, "nickname": nickname, "password": password], encoding: JSONEncoding.default)
        case .getMyFilter(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .createMyFilter(let adjust,
                             let clarity,
                             let colorFilter,
                             let contrast,
                             let exposure,
                             let fade,
                             let grain,
                             let id,
                             let name,
                             let saturation,
                             let sharpen,
                             let splitTone,
                             let tone,
                             let vignette,
                             let whiteBalance):
            return .requestParameters(parameters: ["adjust": adjust,
                                                   "clarity": clarity,
                                                   "colorFilter": colorFilter,
                                                   "contrast": contrast,
                                                   "exposure": exposure,
                                                   "fade": fade,
                                                   "grain": grain,
                                                   "id": id,
                                                   "name": name,
                                                   "saturation": saturation,
                                                   "sharpen": sharpen,
                                                   "splitTone": splitTone,
                                                   "tone": tone,
                                                   "vignette": vignette,
                                                   "whiteBalance": whiteBalance],
                                      encoding: JSONEncoding.default)
        case .getMyFilterList:
            return .requestPlain
        case .updateMyFilter(let adjust,
                             let clarity,
                             let colorFilter,
                             let contrast,
                             let exposure,
                             let fade,
                             let grain,
                             let id,
                             let name,
                             let saturation,
                             let sharpen,
                             let splitTone,
                             let tone,
                             let vignette,
                             let whiteBalance):
            return .requestParameters(parameters: ["adjust": adjust,
                                                   "clarity": clarity,
                                                   "colorFilter": colorFilter,
                                                   "contrast": contrast,
                                                   "exposure": exposure,
                                                   "fade": fade,
                                                   "grain": grain,
                                                   "id": id,
                                                   "name": name,
                                                   "saturation": saturation,
                                                   "sharpen": sharpen,
                                                   "splitTone": splitTone,
                                                   "tone": tone,
                                                   "vignette": vignette,
                                                   "whiteBalance": whiteBalance],
                                      encoding: JSONEncoding.default)
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
