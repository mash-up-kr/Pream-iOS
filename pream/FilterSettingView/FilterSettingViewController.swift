//
//  FilterSettingViewController.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit
import GPUImage

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var previewImageView: GPUImageView!
    @IBOutlet weak var filterSettingTopIcon: UIImageView!
    @IBOutlet weak var filterSettingTopViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomSizeView: UIView!
    @IBOutlet weak var effectNameLabel: UILabel!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    var currentValue: Float?
    var gpuImage: GPUImagePicture?
    lazy var gpuGroupFilter: GPUImageFilterGroup = {
       let groupFilter = GPUImageFilterGroup()
        groupFilter.addFilter(gpuExposureFilter)
        groupFilter.addFilter(gpuContrastFilter)
        return groupFilter
    }()
    var gpuExposureFilter: GPUImageExposureFilter = GPUImageExposureFilter()
    var gpuContrastFilter: GPUImageContrastFilter = GPUImageContrastFilter()

    @IBAction private func changedValue(_ sender: UISlider) {
        currentValue = sender.value
        valueLabel.text = "\(sender.value)"
        if effectNameLabel.text == "Exposure" {
            gpuExposureFilter.exposure = CGFloat(sender.value)
        } else {
            gpuContrastFilter.contrast = CGFloat(sender.value)
        }

        gpuImage?.processImage()
    }
    @IBAction private func closeButtonAction(_ sender: Any) {
        setDefaultConstraints()
    }
    @IBAction private func acceptButtonAction(_ sender: Any) {
        setDefaultConstraints()
    }
    @IBAction private func dissmissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Library", bundle: nil)
        guard let textInputDimedViewController = storyboard.instantiateViewController(withIdentifier: "TextInputDimedViewController") as? TextInputDimedViewController else { return }
        textInputDimedViewController.delegate = self
        textInputDimedViewController.setText(mainTitle: "Share your filter", message: "Explain when it is best\nto use your filter")
        present(textInputDimedViewController, animated: true, completion: nil)
    }

    @IBAction private func imageSelectButton(_ sender: Any) {
        let alert = UIAlertController(title: "Image Select", message: "Please Select an Image", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [weak self] _ in
            let storyboard = UIStoryboard(name: "Library", bundle: nil)
            guard let libraryViewController = storyboard.instantiateViewController(withIdentifier: "LibraryViewController") as? LibraryViewController else { return }
            libraryViewController.delegate = self
            self?.present(libraryViewController, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Random", style: .default, handler: { _ in
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDefaultConstraints()
    }
}

extension FilterSettingViewController: LibraryDelegate {
    func setDefaultConstraints() {
        filterSettingTopViewBottomConstraints.constant = 110
        bottomViewTopConstraints.constant = bottomSizeView.frame.height

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    func selectImage(data: Data?) {
        if let data = data {
            let image = UIImage(data: data)
            gpuImage = GPUImagePicture(image: image)

            gpuExposureFilter.addTarget(gpuContrastFilter)

            gpuGroupFilter.initialFilters = [gpuExposureFilter]
            gpuGroupFilter.terminalFilter = gpuContrastFilter
            gpuImage?.addTarget(gpuGroupFilter)
            gpuGroupFilter.addTarget(previewImageView)
            gpuImage?.processImage()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FilterSettingViewController: TextInputDimedViewDelegate {
    func doneButtonAction(textField: String?) {

    }
}

extension FilterSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Effects.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterSelectCollectionViewCell", for: indexPath) as? FilterSelectCollectionViewCell,
            let effect = Effects(rawValue: indexPath.item) else { return UICollectionViewCell() }
        cell.setEffect(effect)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let effect = Effects(rawValue: indexPath.item) else { return }
        filterSettingTopIcon.image = effect.getImage()
        effectNameLabel.text = effect.getText()
        filterSettingTopViewBottomConstraints.constant = 0
        bottomViewTopConstraints.constant = 0
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
