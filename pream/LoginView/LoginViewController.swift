//
//  LoginViewController.swift
//  pream
//
//  Created by 이재성 on 06/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class LoginViewController: KeyboardViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func loginButtonAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        PreamProvider().login(email: email, password: password, completion: { data in
            Log.msg(data)
        }) { error in
            Log.msg(error)
        }
    }
}
