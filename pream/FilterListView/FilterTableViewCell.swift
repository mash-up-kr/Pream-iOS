//
//  FilterTableViewCell.swift
//  pream
//
//  Created by Gaon Kim on 18/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

protocol FilterTableViewCellDelegate: class {
    func filterTableViewCell(_ sender: FilterTableViewCell, viewControllerToPresent: UIViewController)
    func filterTableViewCell(_ sender: FilterTableViewCell, alertToPresent: UIAlertController)
}

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterTitleView: UILabel!
    @IBOutlet weak var uploadButton: UIButton!

    weak var delegate: FilterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        filterImageView.layer.cornerRadius = 2
    }

    @IBAction private func uploadButtonAction() {
        let storyboard = UIStoryboard(name: "Library", bundle: nil)
        guard let textInputDimedViewController = storyboard.instantiateViewController(withIdentifier: "TextInputDimedViewController") as? TextInputDimedViewController else { return }
        textInputDimedViewController.delegate = self
        textInputDimedViewController.setText(mainTitle: "Share your filter", message: "Explain when it is best\nto use your filter")
        delegate?.filterTableViewCell(self, viewControllerToPresent: textInputDimedViewController)
    }
}

extension FilterTableViewCell: TextInputDimedViewDelegate {
    func doneButtonAction(textField: String?) {
        let alert = UIAlertController(title: "Submitted Successfully!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        delegate?.filterTableViewCell(self, alertToPresent: alert)
    }
}
