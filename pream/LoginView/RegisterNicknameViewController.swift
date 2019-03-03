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
    @IBOutlet weak var nextButton: UIButton!

    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nicknameTextField.becomeFirstResponder()
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction private func previousButtonAction(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func textFieldChangedAction(_ sender: Any) {
        nicknameTextField.activateButtonIfNotEmpty(button: nextButton)
    }

    @IBAction private func nextButtonAction(_ sender: Any) {
        guard let nickname = nicknameTextField.text else { return }
        PreamProvider().signupCheckNickname(nickname: nickname, completion: { [weak self] data in
            Log.msg(data)
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let checkNicknameResponse = try decoder.decode(CheckNicknameResponse.self, from: data)
                let nickname = checkNicknameResponse.result.nickname
                guard let email = self?.email,
                    let password = self?.password else { return }
                PreamProvider().signupSave(email: email, nickname: nickname, password: password, completion: { [weak self] data in
                    Log.msg(data)
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Welcome")
                    self?.navigationController?.show(viewController, sender: nil)
                }, failure: { error in
                    Log.msg(error)
                })
            } catch {
                Log.msg(error)
            }
        }) { error in
            Log.msg(error)
        }
    }
}
