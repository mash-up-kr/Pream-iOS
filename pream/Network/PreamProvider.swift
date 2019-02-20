//
//  PreamProvider.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation
import Result
import Moya

class PreamProvider {
    let provider = MoyaProvider<PreamService>()

    func login(email: String, password: String, completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.login(email: email, password: password)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func signupCheckEmail(email: String, completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.signupCheckEmail(email: email)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func signupCheckNickname(nickname: String, completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.signupCheckNickname(nickname: nickname)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func signupSave(email: String, nickname: String, password: String, completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.signupSave(email: email, nickname: nickname, password: password)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func createMyFilter(adjust: Float,
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
                        whiteBalance: Float,
                        completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.createMyFilter(adjust: adjust,
                                         clarity: clarity,
                                         colorFilter: colorFilter,
                                         contrast: contrast,
                                         exposure: exposure,
                                         fade: fade,
                                         grain: grain,
                                         id: id,
                                         name: name,
                                         saturation: saturation,
                                         sharpen: sharpen,
                                         splitTone: splitTone,
                                         tone: tone,
                                         vignette: vignette,
                                         whiteBalance: whiteBalance)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func getMyFilterList(completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.getMyFilterList) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
    func updateMyFilter(adjust: Float,
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
                        whiteBalance: Float,
                        completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        provider.request(.updateMyFilter(adjust: adjust,
                                         clarity: clarity,
                                         colorFilter: colorFilter,
                                         contrast: contrast,
                                         exposure: exposure,
                                         fade: fade,
                                         grain: grain,
                                         id: id,
                                         name: name,
                                         saturation: saturation,
                                         sharpen: sharpen,
                                         splitTone: splitTone,
                                         tone: tone,
                                         vignette: vignette,
                                         whiteBalance: whiteBalance)) { result in
            self.resultTask(result, completion: completion, failure: failure)
        }
    }
    
//    provider.request(.updateUser(id: 123, firstName: "Harry", lastName: "Potter")) { result in
//    }
}

extension PreamProvider {
    func resultTask(_ result: Result<Response, MoyaError>, completion: @escaping ((Data?) -> Void), failure: @escaping ((Error) -> Void)) {
        switch result {
        case let .success(response):
            let data = response.data
            let statusCode = response.statusCode
            if statusCode >= 300 {
                failure(MoyaError.statusCode(response))
            } else {
                completion(data)
            }
        case let .failure(error):
            failure(error)
        }
    }
}
