//
//  RegisterEmailCheckViewController.swift
//  pream
//
//  Created by Suji Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RegisterEmailCheckViewController: UIViewController {
    @IBOutlet weak var authenticationCodeTextField: UITextField!

    var email: String?
    var authNumber: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        authenticationCodeTextField.becomeFirstResponder()
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func nextButtonAction(_ sender: Any) {
        guard let authNumber = authNumber,
            let authenticationCode = authenticationCodeTextField.text else { return }

        if authNumber == authenticationCode {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterPassword") as? RegisterPasswordViewController else { return }
            viewController.email = email
            navigationController?.show(viewController, sender: nil)
        }
    }
}
