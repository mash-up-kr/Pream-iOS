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
import MediaPlayer

class CameraViewController: UIViewController {
    @IBOutlet weak var shotView: UIView!
    @IBOutlet weak var gpuImageView: GPUImageView!
    @IBOutlet weak var shotEffectView: UIView!
    @IBOutlet weak var cameraShotButton: RoundView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var convertCameraButton: UIButton!
    @IBOutlet weak var changeRatioButton: UIButton!
    @IBOutlet weak var setTimerButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var topBlurView: BlurView!
    @IBOutlet weak var bottomBlurView: BlurView!
    @IBOutlet weak var bottomBlurViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topBlurViewHeight: NSLayoutConstraint!
    @IBOutlet weak var timerCount: UILabel!

    var isLogin: Bool = false
    var videoCamera: GPUImageVideoCamera?
    var filterGroup: GPUImageFilterGroup?
    var isDuringbuttonColorAnimation = false
    var cameraPosition: AVCaptureDevice.Position = .front
    var currentRatio: CameraRatio = .fourthree
    var seconds: Int = Int()
    var timer: Timer = Timer()

    var obs: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        timerCount.isHidden = true
        startCameraSession()
        addBlur()
        registerDoubleTapShotView()
        listenVolumeButton()
        addVolumeButtonObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setRatio()
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
        captureImage()
    }
    //카메라 앞뒤 전환 동장
    @IBAction private func convertCamera(_ sender: UIButton) {
        changeCamaraPosition()
    }
    //비율조정 동작
    @IBAction private func changeRatio(_ sender: UIButton) {
        currentRatio.next()
        setRatio()
    }
    // 타이머
    @IBAction private func didTabOnTimerButton(_ sender: UIButton) {
        initTimer()
        runTimer()
    }
}

extension CameraViewController {
    func captureImage() {
        filterGroup?.useNextFrameForImageCapture()
        guard let image = filterGroup?.imageFromCurrentFramebuffer() else { return }
        let newImage = cropImage(image: image)
        shotEffectView.alpha = 0.7
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.shotEffectView.alpha = 0
        }
        UIImageWriteToSavedPhotosAlbum(newImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func cropImage(image: UIImage) -> UIImage {
        let maxValue = max(image.size.height, image.size.width)
        let imageScale = maxValue / view.frame.height
        let shotViewFrame = shotView.frame
        let imageWidth = shotViewFrame.width * imageScale
        let imageHeight = shotViewFrame.height * imageScale
        let imageX = shotView.center.x * imageScale - (imageWidth / 2)
        let imageY = shotView.center.y * imageScale - (imageHeight / 2)
        let imageCropFrame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        return image.crop(rect: imageCropFrame)
    }

    func setRatio() {
        switch currentRatio {
        case .oneone:
            let topConstant = 108 + view.safeAreaInsets.top
            topBlurViewHeight.constant = topConstant
            bottomBlurViewHeight.constant = view.frame.height - view.frame.width - topConstant
            filterView.backgroundColor = UIColor.clear
        case .fourthree:
            let topConstant = 63 + view.safeAreaInsets.top
            topBlurViewHeight.constant = topConstant
            bottomBlurViewHeight.constant = view.frame.height - (view.frame.width / 3 * 4) - topConstant
            filterView.backgroundColor = UIColor.clear
        case .full:
            topBlurViewHeight.constant = 0
            bottomBlurViewHeight.constant = 0
            filterView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)

        }

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
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
//        Exposure ranges from -10.0 to 10.0, with 0.0 as the normal level
        let exposureFilter = GPUImageExposureFilter()
        exposureFilter.exposure = 0.5
        let contrastFilter = GPUImageContrastFilter()
        let sharpenFilter = GPUImageSharpenFilter()
        let saturationFilter = GPUImageSaturationFilter()
        let whiteBalanceFilter = GPUImageWhiteBalanceFilter()
        let vignetteFilter = GPUImageVignetteFilter()
//        let toneFilter = GPUImageToneCurveFilter()
        //        let adjustFilter = gpuimagea
        //        let clarityFilter = gpuimageclari
        //        let grainFilter = gpuimagegrain
        //        let fadeFilter = gpuimagefade
        //        let splittoneFilter = gpuimagespli
        //        let colorFilter = gpuimagecolor

        filterGroup?.addTarget(exposureFilter)
        //        filterGroup?.addTarget(contrastFilter)
        //        filterGroup?.addTarget(sharpenFilter)
        //        filterGroup?.addTarget(saturationFilter)
        //        filterGroup?.addTarget(toneFilter)
        //        filterGroup?.addTarget(whiteBalanceFilter)
        filterGroup?.initialFilters = [exposureFilter]
        filterGroup?.terminalFilter = exposureFilter

        videoCamera?.addTarget(filterGroup)
        filterGroup?.addTarget(gpuImageView)
    }
    //카메라 동작
    func startCameraSession() {
        let device = UIDevice.current.name
        if device == "iPhone SE" {
            videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.high.rawValue, cameraPosition: cameraPosition)
        } else {
            videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSession.Preset.hd1920x1080.rawValue, cameraPosition: cameraPosition)
        }

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
        } else {
            filterView.isHidden = true
        }
    }

    // 카메라 전환
    func changeCamaraPosition() {
        videoCamera?.stopCapture()
        cameraPosition = cameraPosition == .front ? .back : .front
        startCameraSession()
    }

    // 더블탭 카메라 전환
    func registerDoubleTapShotView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTab))
        tap.numberOfTapsRequired = 2
        gpuImageView.addGestureRecognizer(tap)
    }

    @objc func handleDoubleTab(_ gestureRecognizer: UITapGestureRecognizer) {
        changeCamaraPosition()
    }

    // 볼륨키로 카메라 찍기
    func listenVolumeButton() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true, options: [])
            audioSession.addObserver(self, forKeyPath: "outputVolume",
                                     options: NSKeyValueObservingOptions.new, context: nil)
        } catch {
            print("Error at volume button shot")
        }
    }

    func addVolumeButtonObserver() {
        let volumeView = MPVolumeView(frame: .zero)
        view.addSubview(volumeView)
        let audioSession = AVAudioSession.sharedInstance()
        obs = audioSession.observe( \.outputVolume ) {[weak self] _, _ in
            self?.captureImage()
        }
    }

    // 타이머 선택시 사진 찍기
    func initTimer() {
        // get seconds from timer
        seconds = 4
        // visible timer count label
        timerCount.isHidden = false
    }

    func deinitTimer() {
        timer.invalidate()
        timerCount.isHidden = true
        seconds = Int()
    }

    func runTimer() {
        // timer init run
        updateTimerLabel()

        // run timer
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(CameraViewController.updateTimerLabel),
                                     userInfo: nil,
                                     repeats: true)
    }

    @objc func updateTimerLabel() {
        seconds -= 1

        if seconds > 0 {
            timerCount.text = String(seconds)
        } else {
            deinitTimer()
            captureImage()
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
        let screenSize = gpuImageView.bounds.size
        let focusPoint = CGPoint(x: touchPoint.location(in: gpuImageView).y / screenSize.height, y: 1.0 - touchPoint.location(in: gpuImageView).x / screenSize.width)

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
