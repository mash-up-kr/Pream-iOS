//
//  UserDefaultsManager.swift
//  pream
//
//  Created by JERCY on 25/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    enum key: String {
        case cameraPosition
        case currentRatio
        case userEmail
        case userNickName
    }

    static let shared: UserDefaultsManager = UserDefaultsManager()
    let userDefault: UserDefaults = UserDefaults.standard

    func setCameraPositionIntoUserDefault(cameraPosition: AVCaptureDevice.Position) {
        userDefault.set(cameraPosition.rawValue, forKey: key.cameraPosition.rawValue)
    }

    func setCurrentRatioIntoUserDefaults(currentRatio: CameraRatio) {
        userDefault.set(currentRatio.rawValue, forKey: key.currentRatio.rawValue)
    }

    func setUser(user: User) {
        userDefault.set(user.email, forKey: key.userEmail.rawValue)
        userDefault.set(user.nickName, forKey: key.userNickName.rawValue)
    }

    func getCameraPosition() -> AVCaptureDevice.Position {
        return AVCaptureDevice.Position(rawValue: userDefault.integer(forKey: key.cameraPosition.rawValue)) ?? .front
    }

    func getCameraRatio() -> CameraRatio {
        return CameraRatio(rawValue: userDefault.integer(forKey: key.currentRatio.rawValue)) ?? .fourthree
    }

    func getUser() -> User? {
        let email = userDefault.string(forKey: key.userEmail.rawValue)
        let nickName = userDefault.string(forKey: key.userNickName.rawValue)
        guard let userEmail = email, let userNickName = nickName else { return nil }
        return User(nickName: userNickName, email: userEmail)
    }
}
