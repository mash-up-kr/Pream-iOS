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

class CameraViewController: UIViewController {
    @IBOutlet weak var cameraPreviewImageView: UIImageView!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraPosition: AVCaptureDevice.Position = {
        let position = AVCaptureDevice.Position.back
        return position
    }()

    var isLogin: Bool = {
        let isLogin = false
        return isLogin
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loginChecked()
        startCameraSession()
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
        //임시로 찍을때마다 카메라 앞뒤로 바뀌도록 함
        changeCameraPosition()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
}

// MARK: - CheckLogin
extension CameraViewController {
    func loginChecked() {
        guard !isLogin else { return }
        isLogin.toggle()

        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationViewController")
        present(loginViewController, animated: true, completion: nil)
    }
}
