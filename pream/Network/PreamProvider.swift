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
