//
//  FoodFilterViewController.swift
//  pream
//
//  Created by Suji Kim on 21/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FoodFilterViewController: UIViewController {

    @IBOutlet weak var firstFilterImageView: UIImageView!
    @IBOutlet weak var secondFilterImageView: UIImageView!
    @IBOutlet weak var thirdFilterImageView: UIImageView!
    @IBOutlet weak var fourthFilterImageView: UIImageView!

    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var firstFilterImageButton: UIButton!
    @IBOutlet weak var secondFilterImageButton: UIButton!
    @IBOutlet weak var thirdFilterImageButton: UIButton!
    @IBOutlet weak var fourthFilterImageButton: UIButton!

    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nextButton.isEnabled = false
    }

    @IBAction func filterImageButtonsAction(_ sender: UIButton) {
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
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        if sender.isEnabled {
            let storyboard = UIStoryboard(name: "DefaultFilterRegister", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "ObjectFilterViewController") as? ObjectFilterViewController else {
                return
            }
            navigationController?.show(viewController, sender: nil)
//            (viewController, animated: true, completion: nil)
        }
    }
}
