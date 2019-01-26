//
//  CameraManager.swift
//  pream
//
//  Created by 이재성 on 26/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import Foundation
import AVKit

protocol CameraManagerDelegate: class {
    func captureOutput(image: UIImage)
}

class CameraManager: UIImageView, PresentError {
    var cameraPosition: AVCaptureDevice.Position = .front
    weak var delegate: CameraManagerDelegate?

    var session: AVCaptureSession?
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?

    func startSession() {
        session = setupAVCaptureSession()
        session?.startRunning()
    }

    func endSession() {
        session?.stopRunning()
    }

    func reloadSession() {
        endSession()
        startSession()
    }

    func cameraPositionChange() {
        if cameraPosition == .back {
            cameraPosition = .front
        } else {
            cameraPosition = .back
        }

        reloadSession()
    }
}

extension CameraManager {
    func sampleBufferToUIImage(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Log.msg("Failed to obtain a CVPixelBuffer for the current output frame.")
            return nil
        }
        let exifOrientation = self.exifOrientationForCurrentDeviceOrientation()
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(exifOrientation)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupAVCaptureSession() -> AVCaptureSession? {
        let captureSession = AVCaptureSession()
        do {
            let inputDevice = try configureCamera(for: captureSession, cameraPosition: cameraPosition)
            configureVideoDataOutput(for: inputDevice.device, resolution: inputDevice.resolution, captureSession: captureSession)
            return captureSession
        } catch let executionError as NSError {
            presentError(executionError)
        } catch {
            presentErrorAlert(message: "An unexpected failure has occured")
        }

        teardownAVCapture()

        return nil
    }

    func highestResolution420Format(for device: AVCaptureDevice) -> (format: AVCaptureDevice.Format, resolution: CGSize)? {
        var highestResolutionFormat: AVCaptureDevice.Format?
        var highestResolutionDimensions = CMVideoDimensions(width: 0, height: 0)

        for format in device.formats {
            let deviceFormat = format as AVCaptureDevice.Format

            let deviceFormatDescription = deviceFormat.formatDescription
            if CMFormatDescriptionGetMediaSubType(deviceFormatDescription) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange {
                let candidateDimensions = CMVideoFormatDescriptionGetDimensions(deviceFormatDescription)
                if (highestResolutionFormat == nil) || (candidateDimensions.width > highestResolutionDimensions.width) {
                    highestResolutionFormat = deviceFormat
                    highestResolutionDimensions = candidateDimensions
                }
            }
        }

        if highestResolutionFormat != nil {
            let resolution = CGSize(width: CGFloat(highestResolutionDimensions.width), height: CGFloat(highestResolutionDimensions.height))
            return (highestResolutionFormat!, resolution)
        }

        return nil
    }

    func configureCamera(for captureSession: AVCaptureSession, cameraPosition: AVCaptureDevice.Position) throws -> (device: AVCaptureDevice, resolution: CGSize) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: cameraPosition)

        if let device = deviceDiscoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                }

                if let highestResolution = highestResolution420Format(for: device) {
                    try device.lockForConfiguration()
                    device.activeFormat = highestResolution.format
                    device.unlockForConfiguration()

                    return (device, highestResolution.resolution)
                }
            }
        }

        throw NSError(domain: "ViewController", code: 1, userInfo: nil)
    }

    func configureVideoDataOutput(for inputDevice: AVCaptureDevice, resolution: CGSize, captureSession: AVCaptureSession) {

        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames = true

        let videoDataOutputQueue = DispatchQueue(label: "kr.co.mashup.pream")
        videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)

        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }

        videoDataOutput.connection(with: .video)?.isEnabled = true

        if let captureConnection = videoDataOutput.connection(with: AVMediaType.video) {
            if captureConnection.isCameraIntrinsicMatrixDeliverySupported {
                captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
            }
        }

        self.videoDataOutput = videoDataOutput
        self.videoDataOutputQueue = videoDataOutputQueue
    }

    func teardownAVCapture() {
        videoDataOutput = nil
        videoDataOutputQueue = nil
    }

    func exifOrientationForDeviceOrientation(_ deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        if cameraPosition == .front {
            return .leftMirrored
        }
        return .right
    }

    func exifOrientationForCurrentDeviceOrientation() -> CGImagePropertyOrientation {
        return exifOrientationForDeviceOrientation(UIDevice.current.orientation)
    }
}

extension CameraManager {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

        guard let image = sampleBufferToUIImage(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.captureOutput(image: image)
            self?.image = image
        }
    }
}
