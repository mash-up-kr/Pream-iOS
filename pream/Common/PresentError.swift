//
//  PresentError.swift
//  pream
//
//  Created by 이재성 on 26/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

protocol PresentError {
    func presentErrorAlert(withTitle title: String, message: String)
    func presentError(_ error: NSError)
}

extension PresentError where Self: UIViewController {
    func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true)
    }

    func presentError(_ error: NSError) {
        presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
}

extension PresentError where Self: UIView {
    func presentErrorAlert(withTitle title: String = "Unexpected Failure", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        parentViewController?.present(alertController, animated: true)
    }

    func presentError(_ error: NSError) {
        presentErrorAlert(withTitle: "Failed with error \(error.code)", message: error.localizedDescription)
    }
}
