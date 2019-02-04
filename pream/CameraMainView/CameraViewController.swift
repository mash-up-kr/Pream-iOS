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
import GPUImage

class CameraViewController: UIViewController {
    @IBOutlet weak var gpuImageView: GPUImageView!
    @IBOutlet weak var shotEffectView: UIView!
    @IBOutlet weak var cameraShotButton: RoundView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var convertCameraButton: UIButton!
    @IBOutlet weak var changeRatioButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var topBlurView: BlurView!
    @IBOutlet weak var bottomBlurView: BlurView!
    @IBOutlet weak var bottomViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonWidthConstraint: NSLayoutConstraint!
    var isLogin: Bool = true
    var videoCamera: GPUImageVideoCamera?
    var filterGroup: GPUImageFilterGroup?
    var isDuringbuttonColorAnimation = false
    var cameraPosition: AVCaptureDevice.Position = .front

    override func viewDidLoad() {
        super.viewDidLoad()

        startCameraSession()
        addBlur()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loginChecked()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    //사진촬영 버튼 동작
    @IBAction private func didTabOnShotButton(_ sender: UIButton) {
        filterGroup?.useNextFrameForImageCapture()
        guard let image = filterGroup?.imageFromCurrentFramebuffer() else { return }
        shotEffectView.alpha = 0.7
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.shotEffectView.alpha = 0
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    //카메라 앞뒤 전환 동장
    @IBAction private func convertCamera(_ sender: UIButton) {
        videoCamera?.stopCapture()
        if cameraPosition == .front {
            cameraPosition = .back
        } else {
            cameraPosition = .front
        }
        videoCamera?.imageFromCurrentFramebuffer()
        startCameraSession()
    }
    //비율조정 동작
    @IBAction private func changeRatio(_ sender: UIButton) {
        Log.msg("changeRatio")
    }
}

extension CameraViewController {
    func touchToFocus() {
        do {
            try videoCamera?.inputCamera.lockForConfiguration()
//            videoCamera?.inputCamera.focusMode = .continuousAutoFocus
//            videoCamera?.inputCamera.setFocusModeLocked(lensPosition: 0.5, completionHandler: nil)
            videoCamera?.inputCamera.unlockForConfiguration()
        } catch let error as NSError {
            Log.msg(error)
        }
    }
    //필터 추가
    func addFilter() {
        filterGroup = GPUImageFilterGroup()
        let beautyFilter = GPUImageBeautifyFilter()

        filterGroup?.addTarget(beautyFilter)

        filterGroup?.initialFilters = [beautyFilter]
        filterGroup?.terminalFilter = beautyFilter

        videoCamera?.addTarget(filterGroup)
        filterGroup?.addTarget(gpuImageView)
    }
    //카메라 동작
    func startCameraSession() {
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.hd1920x1080.rawValue, cameraPosition: cameraPosition)
        videoCamera?.outputImageOrientation = .portrait
        videoCamera?.delegate = self
        videoCamera?.horizontallyMirrorFrontFacingCamera = true
        addFilter()
        videoCamera?.startCapture()
        touchToFocus()
    }
    //실시간으로 이미지 버퍼를 읽어와서 사진촬영 버튼 색상 변경
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
    //사진촬영 성공시 호출되는 함수
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
    //첫 진입시 로그인 체크
    func loginChecked() {
        guard !isLogin else { return }
        isLogin.toggle()

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController")
        present(loginViewController, animated: true, completion: nil)
    }

    //상하단 블러 추가
    func addBlur() {
        let blur = UIBlurEffect(style: .regular)
        let topBlurEffectView = UIVisualEffectView(effect: blur)
        let bottomBlurEffectView = UIVisualEffectView(effect: blur)

        topBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        bottomBlurEffectView.translatesAutoresizingMaskIntoConstraints = false

        gpuImageView.addSubview(topBlurEffectView)
        gpuImageView.addSubview(bottomBlurEffectView)

        topBlurEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(topBlurView)
        }

        bottomBlurEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(bottomBlurView)
        }
    }

    //필터뷰 보기
    @IBAction private func showFilter(_ sender: UIButton) {
        if filterView.isHidden {
            filterView.isHidden = false
            bottomViewHeightConstriant.constant = 76
            cameraButtonHeightConstraint.constant = 46
            cameraButtonWidthConstraint.constant = 46
            cameraButtonBottomConstraint.constant = 15
        } else {
            filterView.isHidden = true
            bottomViewHeightConstriant.constant = 104
            cameraButtonHeightConstraint.constant = 60
            cameraButtonWidthConstraint.constant = 60
            cameraButtonBottomConstraint.constant = 20
        }
    }
}

extension CameraViewController: GPUImageVideoCameraDelegate {
    // 실시간으로 샘플버퍼 읽기
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        guard let image = sampleBufferToUIImage(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.captureOutput(image: image)
        }
    }
    //샘플버퍼를 uiimage로 변경
    func sampleBufferToUIImage(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Log.msg("Failed to obtain a CVPixelBuffer for the current output frame.")
            return nil
        }
        let exifOrientation = exifOrientationForCurrentDeviceOrientation()
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(exifOrientation)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    //화면 전환 체크
    func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        if cameraPosition == .front {
            return .leftMirrored
        }
        return .right
    }

    func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first else { return }
        let screenSize = view.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: view).y / screenSize.height, y: 1.0 - touchPoint.location(in: view).x / screenSize.width)

        if let device = videoCamera?.inputCamera {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                }
                device.unlockForConfiguration()
            } catch {
            }
        }
    }
}
