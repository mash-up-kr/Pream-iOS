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
    var currentFilter: Effects = .exposure
    var currentValue: Float?
    var gpuImage: GPUImagePicture?
    lazy var gpuGroupFilter: GPUImageFilterGroup = {
       let groupFilter = GPUImageFilterGroup()
        groupFilter.addFilter(gpuExposureFilter)
        groupFilter.addFilter(gpuContrastFilter)
        groupFilter.addFilter(gpuSharpenFilter)
        groupFilter.addFilter(gpuSaturationFilter)
        groupFilter.addFilter(gpuHighlightFilter)
        groupFilter.addFilter(gpuWhiteBalanceFilter)
        groupFilter.addFilter(gpuVignetteFilter)

        gpuExposureFilter.addTarget(gpuContrastFilter)
        gpuContrastFilter.addTarget(gpuSharpenFilter)
        gpuSharpenFilter.addTarget(gpuSaturationFilter)
        gpuSaturationFilter.addTarget(gpuHighlightFilter)
        gpuHighlightFilter.addTarget(gpuWhiteBalanceFilter)
        gpuWhiteBalanceFilter.addTarget(gpuVignetteFilter)

        groupFilter.initialFilters = [gpuExposureFilter]
        groupFilter.terminalFilter = gpuVignetteFilter

        return groupFilter
    }()
    var gpuExposureFilter: GPUImageExposureFilter = GPUImageExposureFilter()
    var gpuContrastFilter: GPUImageContrastFilter = GPUImageContrastFilter()
    var gpuSharpenFilter: GPUImageSharpenFilter = GPUImageSharpenFilter()
    var gpuSaturationFilter: GPUImageSaturationFilter = GPUImageSaturationFilter()
    var gpuHighlightFilter: GPUImageHighlightShadowFilter = GPUImageHighlightShadowFilter()
    var gpuWhiteBalanceFilter: GPUImageWhiteBalanceFilter = GPUImageWhiteBalanceFilter()
    var gpuVignetteFilter: GPUImageVignetteFilter = GPUImageVignetteFilter()

    @IBAction private func changedValue(_ sender: UISlider) {
        currentValue = sender.value
        valueLabel.text = "\(sender.value)"
        switch currentFilter {
        case .exposure:
            gpuExposureFilter.exposure = CGFloat(sender.value)
        case .contrast:
            gpuContrastFilter.contrast = CGFloat(sender.value)
        case .sharpen:
            gpuSharpenFilter.sharpness = CGFloat(sender.value)
        case .saturation:
            gpuSaturationFilter.saturation = CGFloat(sender.value)
        case .highlight:
            gpuHighlightFilter.highlights = CGFloat(sender.value)
        case .shadow:
            gpuHighlightFilter.shadows = CGFloat(sender.value)
        case .whiteBalance:
            gpuWhiteBalanceFilter.temperature = CGFloat(sender.value)
        case .vignette:
            gpuVignetteFilter.vignetteEnd = CGFloat(sender.value)
        case .grain:
            Log.msg("grain")
        case .fade:
            Log.msg("grain")
        case .splitTone:
            Log.msg("grain")
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
        switch effect {
        case .exposure:
            sliderOutlet.value = Float(gpuExposureFilter.exposure)
        case .contrast:
            sliderOutlet.value = Float(gpuContrastFilter.contrast)
        case .sharpen:
            sliderOutlet.value = Float(gpuSharpenFilter.sharpness)
        case .saturation:
            sliderOutlet.value = Float(gpuSaturationFilter.saturation)
        case .highlight:
            sliderOutlet.value = Float(gpuHighlightFilter.highlights)
        case .shadow:
            sliderOutlet.value = Float(gpuHighlightFilter.shadows)
        case .whiteBalance:
            sliderOutlet.value = Float(gpuWhiteBalanceFilter.temperature)
        case .vignette:
            sliderOutlet.value = Float(gpuVignetteFilter.vignetteEnd)
        case .grain:
            Log.msg("grain")
        case .fade:
            Log.msg("fade")
        case .splitTone:
            Log.msg("splitTone")
        }
        
        filterSettingTopIcon.image = effect.getImage()
        effectNameLabel.text = effect.getText()
        filterSettingTopViewBottomConstraints.constant = 0
        bottomViewTopConstraints.constant = 0
        currentFilter = effect
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
