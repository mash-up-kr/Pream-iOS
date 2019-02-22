//
//  TextInputDimedView.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation

protocol TextInputDimedViewDelegate: class {
    func doneButtonAction(textField: String?)
}

class TextInputDimedViewController: KeyboardViewController {
    var mainTitle: String?
    var message: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    weak var delegate: TextInputDimedViewDelegate?

    @IBAction private func doneButtonAction(_ sender: Any) {
        delegate?.doneButtonAction(textField: inputTextField.text)
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setText(mainTitle: String, message: String) {
        self.mainTitle = mainTitle
        self.message = message
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        inputTextField.delegate = self
        titleLabel.text = mainTitle
        messageLabel.text = message
    }

    override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let margin = (view.frame.height - baseView.frame.height) / 2
            if self.view.frame.origin.y == 0, margin < keyboardSize.height {
                view.frame.origin.y -= keyboardSize.height - margin + 20.0
            }
        }
    }
}

extension TextInputDimedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
