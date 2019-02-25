//
//  SceneryFilterViewController.swift
//  pream
//
//  Created by Suji Kim on 21/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class SceneryFilterViewController: UIViewController {

    @IBOutlet weak var firstFilterImageView: UIImageView!
    @IBOutlet weak var secondFilterImageView: UIImageView!
    @IBOutlet weak var thirdFilterImageView: UIImageView!
    @IBOutlet weak var fourthFilterImageView: UIImageView!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var firstFilterImageButton: UIButton!
    @IBOutlet weak var secondFilterImageButton: UIButton!
    @IBOutlet weak var thirdFilterImageButton: UIButton!
    @IBOutlet weak var fourthFilterImageButton: UIButton!

    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startButton.isEnabled = false
    }

    @IBAction private func filterImageButtonsAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            sender.backgroundColor = .clear
            count -= 1
        } else {
            sender.isSelected = true
            sender.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6000000238)
            count += 1
        }
        if count > 0 {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }

    @IBAction private func nextButtonAction(_ sender: UIButton) {
        if sender.isEnabled {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController else {
                return
            }
            viewController.isLogin = true
            present(viewController, animated: true, completion: nil)
        }
    }
}
