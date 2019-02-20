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
}
