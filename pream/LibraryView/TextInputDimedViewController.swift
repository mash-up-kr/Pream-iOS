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

class TextInputDimedViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputTexteField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    weak var delegate: TextInputDimedViewDelegate?

    @IBAction private func doneButtonAction(_ sender: Any) {
        delegate?.doneButtonAction(textField: inputTexteField.text)
    }

    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setText(mainTitle: String, message: String) {
        titleLabel.text = mainTitle
        messageLabel.text = message
    }
}
