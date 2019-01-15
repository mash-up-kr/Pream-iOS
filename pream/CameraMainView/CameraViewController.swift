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
    @IBOutlet weak var cameraPreviewImageView: UIImageView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var convertCameraButton: UIButton!
    @IBOutlet weak var changeRatioButton: UIButton!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isLogin: Bool = false
    var cameraPosition: AVCaptureDevice.Position = .back
    var imagePicker = UIImagePickerController()

    //gradation Values
    let gradient: CAGradientLayer = CAGradientLayer()
    var currentGradient: Int = 0
    var gradientSet: [[CGColor]] = [[#colorLiteral(red: 0.5529411765, green: 0.7176470588, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.6705882353, green: 0.537254902, blue: 1, alpha: 1).cgColor],
                                    [#colorLiteral(red: 1, green: 0.6392156863, blue: 0.9882352941, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.5254901961, blue: 0.5254901961, alpha: 1).cgColor],
                                    [#colorLiteral(red: 0.6705882353, green: 0.537254902, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.6392156863, blue: 0.9882352941, alpha: 1).cgColor],
                                    [#colorLiteral(red: 1, green: 0.5254901961, blue: 0.5254901961, alpha: 1).cgColor, #colorLiteral(red: 0.5529411765, green: 0.7176470588, blue: 1, alpha: 1).cgColor]]

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loginChecked()
        startCameraSession()
        setLibraryButtonImage()
        addGradation()
        animationShotButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endCameraSession()
    }
}

// MARK: - CameraSessionFuncs
extension CameraViewController {
    func startCameraSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let cameraDevice = getCameraDevice(position: cameraPosition) else {
            Log.msg("Unable to access camera!")
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            Log.msg("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }

    func endCameraSession() {
        captureSession.stopRunning()
    }

    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewImageView.layer.addSublayer(videoPreviewLayer)

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.cameraPreviewImageView.bounds
            }
        }
    }

    func getCameraDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }

    func changeCameraPosition() {
        if cameraPosition == .back {
            cameraPosition = .front
        } else {
            cameraPosition = .back
        }

        reloadCameraSession()
    }

    func reloadCameraSession() {
        endCameraSession()
        startCameraSession()
    }

    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        //우선 사진 저장할 때마다 사진첩버튼 이미지 최신껄로 변경
        setLibraryButtonImage()
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    @IBAction private func didTabOnShotButton(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }
        saveImage(image)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        muteCameraSound()
    }
}

// MARK: - Functions
extension CameraViewController {
    @objc func imageCapture() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            self.stillImageOutput.capturePhoto(with: settings, delegate: self)
        }
    }

    func muteCameraSound() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)

        guard let soundURL = Bundle.main.url(forResource: "photoShutter2", withExtension: "caf") else { return }
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }

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

// MARK: - Photo Library Functions
extension CameraViewController {
    func setLibraryButtonImage() {
        libraryButton.imageView?.contentMode = .scaleAspectFill

        if let asset = fetchLatestPhoto().firstObject {
            // Request the image.
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: self.libraryButton.frame.size,
                                                  contentMode: .aspectFit,
                                                  options: nil) { image, _ in
                self.libraryButton.setImage(image, for: .normal)
            }
        }
    }

    func fetchLatestPhoto() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()

        // 한가지 이미지만 가져오기
        options.fetchLimit = 1

        // 최신순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]

        return PHAsset.fetchAssets(with: .image, options: options)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction private func tapLibraryButton(_ sender: UIButton) {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
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
