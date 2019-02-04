//
//  CameraViewController.swift
//  pream
//
//  Created by jarvis on 04/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit
import SnapKit
import Photos
import SideMenu

class CameraViewController: UIViewController {
    @IBOutlet weak var cameraShotButton: RoundButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var convertCameraButton: UIButton!
    @IBOutlet weak var changeRatioButton: UIButton!
    @IBOutlet weak var cameraManager: CameraManager!
    @IBOutlet weak var filterView: UIView!
    var isLogin: Bool = true

    @IBOutlet weak var topBlurView: BlurView!
    @IBOutlet weak var bottomBlurView: BlurView!

    var isDuringbuttonColorAnimation = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addBlur()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cameraManager.delegate = self
        cameraManager.startSession()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loginChecked()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.endSession()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sideMenuNavigationController = segue.destination as? UISideMenuNavigationController {
            sideMenuNavigationController.sideMenuManager.menuAnimationBackgroundColor = UIColor.clear
            SideMenuManager.default.menuPresentMode = .viewSlideInOut
            SideMenuManager.default.menuShadowOpacity = 0
        }
    }
}

extension CameraViewController {
    @IBAction private func didTabOnShotButton(_ sender: UIButton) {
        guard let image = cameraManager.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction private func convertCamera(_ sender: UIButton) {
        cameraManager.cameraPositionChange()
    }

    @IBAction private func changeRatio(_ sender: UIButton) {
        Log.msg("changeRatio")
    }
}

extension CameraViewController: CameraManagerDelegate {
    func captureOutput(image: UIImage) {
        guard let averageColor = image.averageColor else { return }
        if !isDuringbuttonColorAnimation {
            isDuringbuttonColorAnimation = true
            UIView.animate(withDuration: 1,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: { [weak self] in
                            self?.cameraShotButton.backgroundColor = averageColor
            }) { [weak self] _ in
                self?.isDuringbuttonColorAnimation = false
            }
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "실패", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "저장!", message: "저장 완료.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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

    func addBlur() {
        let blur = UIBlurEffect(style: .regular)
        let topBlurEffectView = UIVisualEffectView(effect: blur)
        let bottomBlurEffectView = UIVisualEffectView(effect: blur)

        topBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        bottomBlurEffectView.translatesAutoresizingMaskIntoConstraints = false

        cameraManager.addSubview(topBlurEffectView)
        cameraManager.addSubview(bottomBlurEffectView)

        topBlurEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(topBlurView)
        }

        bottomBlurEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(bottomBlurView)
        }
    }

    @IBAction private func showFilter(_ sender: UIButton) {
        if filterView.isHidden {
            filterView.isHidden = false
        } else {
            filterView.isHidden = true
        }
    }
}
