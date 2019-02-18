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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        passwordTextField.becomeFirstResponder()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func previousButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
