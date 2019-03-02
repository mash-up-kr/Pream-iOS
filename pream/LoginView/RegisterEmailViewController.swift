//
//  RegisterEmailViewController.swift
//  pream
//
//  Created by Suji Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailTextField.becomeFirstResponder()
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func nextButtonAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        PreamProvider().signupCheckEmail(email: email, completion: { [weak self] data in
            Log.msg(data)
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let checkEmailResponse = try decoder.decode(CheckEmailResponse.self, from: data)
                let authNumber = checkEmailResponse.result.authNumber
                print(authNumber)
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                guard let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterEmailCheck") as? RegisterEmailCheckViewController else { return }
                viewController.email = email
                viewController.authNumber = authNumber
                self?.navigationController?.show(viewController, sender: nil)
            } catch {
                Log.msg(error)
            }
        }) { error in
            Log.msg(error)
        }
    }
}
