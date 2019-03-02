//
//  RegisterPasswordViewController.swift
//  pream
//
//  Created by Suji Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RegisterPasswordViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!

    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? RegisterPasswordCheckViewController,
            let passwordInput = passwordTextField.text else { return }
        viewController.prevPassword = passwordInput
        viewController.email = email
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.becomeFirstResponder()
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
