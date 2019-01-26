//
//  CameraViewController.swift
//  pream
//
//  Created by jarvis on 04/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import Photos
import UIImageColors
import AudioToolbox

class CameraViewController: UIViewController {
    @IBOutlet weak var cameraShotButton: RoundButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var convertCameraButton: UIButton!
    @IBOutlet weak var changeRatioButton: UIButton!
    @IBOutlet weak var cameraManagerView: CameraManager!
    var isLogin: Bool = false

    //gradation Values
    let gradient: CAGradientLayer = CAGradientLayer()
    var currentGradient: Int = 0
    var gradientSet: [[CGColor]] = [[#colorLiteral(red: 0.5529411765, green: 0.7176470588, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.6705882353, green: 0.537254902, blue: 1, alpha: 1).cgColor],
                                    [#colorLiteral(red: 1, green: 0.6392156863, blue: 0.9882352941, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.5254901961, blue: 0.5254901961, alpha: 1).cgColor],
                                    [#colorLiteral(red: 0.6705882353, green: 0.537254902, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.6392156863, blue: 0.9882352941, alpha: 1).cgColor],
                                    [#colorLiteral(red: 1, green: 0.5254901961, blue: 0.5254901961, alpha: 1).cgColor, #colorLiteral(red: 0.5529411765, green: 0.7176470588, blue: 1, alpha: 1).cgColor]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cameraManagerView.startSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loginChecked()
        addGradation()
        animationShotButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManagerView.endSession()
    }
}

extension CameraViewController {
    func changeCameraPosition() {
        if cameraManagerView.cameraPosition == .back {
            cameraManagerView.cameraPosition = .front
        } else {
            cameraManagerView.cameraPosition = .back
        }

        cameraManagerView.reloadSession()
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    @IBAction private func didTabOnShotButton(_ sender: UIButton) {
        cameraManagerView.shotImage()
    }
}

// MARK: - Functions
extension CameraViewController {
    func loginChecked() {
        guard !isLogin else { return }
        isLogin.toggle()

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController")
        present(loginViewController, animated: true, completion: nil)
    }

    func addGradation() {
        gradient.frame = cameraShotButton.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        cameraShotButton.layer.addSublayer(gradient)
        gradient.cornerRadius = cameraShotButton.layer.cornerRadius
    }

    func animationShotButton() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }

        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = Float.infinity
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = .both
        gradient.add(gradientChangeAnimation, forKey: "gradationChange")

    }
}

extension CameraViewController {
    @IBAction private func convertCamera(_ sender: UIButton) {
        changeCameraPosition()
    }

    @IBAction private func changeRatio(_ sender: UIButton) {
        Log.msg("changeRatio")
    }
}
