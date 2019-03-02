//
//  RegisterPasswordCheckViewController.swift
//  pream
//
//  Created by Suji Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RegisterPasswordCheckViewController: UIViewController {
    @IBOutlet weak var passwordCheckTextField: UITextField!

    var email: String?
    var prevPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordCheckTextField.becomeFirstResponder()
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func nextButtonAction(_ sender: Any) {
        guard let prev = prevPassword,
            let password = passwordCheckTextField.text else { return }

        if prev == password {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterNickname") as? RegisterNicknameViewController else { return }
            viewController.email = email
            viewController.password = password
            navigationController?.show(viewController, sender: nil)
        }
    }
}
