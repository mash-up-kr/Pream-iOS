//
//  CameraViewController.swift
//  pream
//
//  Created by jarvis on 04/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController{
    @IBOutlet weak var cameraPreviewImageView: UIImageView!

    var imagePickers:UIImagePickerController? = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        initImagePicker()
    }
    

    // MARK: - IBAction
    @IBAction func didTabOnShotButton(_ sender: UIButton) {
        // capture camera image
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        imagePickers?.takePicture()
    }
    
    // MARK: - Functions
    func initImagePicker() {
        imagePickers?.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickers?.sourceType = UIImagePickerController.SourceType.camera
        present(imagePickers ?? UIImagePickerController(), animated: true, completion: nil)
        addChild(imagePickers!)
        
        self.cameraPreviewImageView.addSubview((imagePickers?.view)!)
        imagePickers?.view.frame = cameraPreviewImageView.bounds
        imagePickers?.allowsEditing = false
        imagePickers?.showsCameraControls = false
        imagePickers?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imagePickers?.cameraFlashMode = .off
    }
}

extension CameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraPreviewImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePickers?.dismiss(animated: true, completion: nil)
        
        saveImage()
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(cameraPreviewImageView.image ?? UIImage(),
                                       self,
                                       #selector(image(_:didFinishSavingWithError:contextInfo:)),
                                       nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {}
}

extension CameraViewController: UINavigationControllerDelegate {
    
}
