//
//  FilterSettingViewController.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!

    @IBAction func saveButtonAction(_ sender: Any) {
    }

    @IBAction private func imageSelectButton(_ sender: Any) {
        let alert = UIAlertController(title: "Image Select", message: "Please Select an Image", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
        }))

        alert.addAction(UIAlertAction(title: "Random", style: .default, handler: { _ in
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
