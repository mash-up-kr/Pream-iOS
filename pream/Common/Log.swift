//
//  Log.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

class Log {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    class func msg(_ message: Any, functionName: String = #function) {
        #if DEBUG
        let output = "<\(formatter.string(from: Date()))> #\(functionName): \(message)"
        print(output)
        #endif
    }
}
