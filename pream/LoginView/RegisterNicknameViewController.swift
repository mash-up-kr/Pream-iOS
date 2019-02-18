//
//  RegisterNicknameViewController.swift
//  pream
//
//  Created by Suji Kim on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class RegisterNicknameViewController: UIViewController {
    @IBOutlet weak var nicknameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nicknameTextField.becomeFirstResponder()
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func previousButtonAction(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
}
