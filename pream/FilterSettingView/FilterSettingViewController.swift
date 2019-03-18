//
//  FilterSettingViewController.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit
import GPUImage
import RealmSwift

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var previewImageView: GPUImageView!
    @IBOutlet weak var filterSettingTopIcon: UIImageView!
    @IBOutlet weak var filterSettingTopViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomSizeView: UIView!
    @IBOutlet weak var effectNameLabel: UILabel!
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var tintSlider: UISlider!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var whiteBalanceView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tintLabel: UILabel!
    var currentFilter: Effects = .exposure
    var currentValue: Float?
    var gpuImage: GPUImagePicture?
    var filterModel: FilterModel = FilterModel()
    var beforeValue: Float = 0
    var beforeTint: Float = 0
    var beforeTemperature: Float = 0

    @IBAction private func temperatureChangedValue(_ sender: UISlider) {
        currentValue = sender.value
        temperatureLabel.text = "\(sender.value)"
        filterModel.groupFilter.setFilter(currentFilter: currentFilter, customField: "temperature", value: CGFloat(sender.value))
        gpuImage?.processImage()
    }
    @IBAction private func tintChangedValue(_ sender: UISlider) {
        currentValue = sender.value
        tintLabel.text = "\(sender.value)"
        filterModel.groupFilter.setFilter(currentFilter: currentFilter, customField: "tint", value: CGFloat(sender.value))
        gpuImage?.processImage()
    }
    @IBAction private func changedValue(_ sender: UISlider) {
        currentValue = sender.value
        valueLabel.text = "\(sender.value)"
        filterModel.groupFilter.setFilter(currentFilter: currentFilter, value: CGFloat(sender.value))
        gpuImage?.processImage()
    }
    @IBAction private func closeButtonAction(_ sender: Any) {
        sliderOutlet.value = beforeValue
        tintSlider.value = beforeTint
        temperatureSlider.value = beforeTemperature

        if currentFilter == .whiteBalance {
            filterModel.groupFilter.setFilter(currentFilter: currentFilter, customField: "temperature", value: CGFloat(beforeTemperature))
            filterModel.groupFilter.setFilter(currentFilter: currentFilter, customField: "tint", value: CGFloat(beforeTint))
        } else {
            filterModel.groupFilter.setFilter(currentFilter: currentFilter, value: CGFloat(beforeValue))
        }
        gpuImage?.processImage()
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
        textInputDimedViewController.setText(mainTitle: "", message: "What’s your filters name?")
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

            gpuImage?.addTarget(filterModel.groupFilter.gpuGroupFilter)
            filterModel.groupFilter.gpuGroupFilter.addTarget(previewImageView)
            gpuImage?.processImage()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FilterSettingViewController: TextInputDimedViewDelegate {
    func doneButtonAction(textField: String?) {
        filterModel.groupName = textField

        filterModel.groupFilter.gpuGroupFilter.useNextFrameForImageCapture()
        filterModel.groupImage = filterModel.groupFilter.gpuGroupFilter.imageFromCurrentFramebuffer()

        let realm = try! Realm()
        realm.beginWrite()
        realm.add(filterModel.makeObject())
        try! realm.commitWrite()

        dismiss(animated: true, completion: nil)
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
        if effect == .whiteBalance {
            whiteBalanceView.isHidden = false
            let sliderTemperatureValue = filterModel.groupFilter.getMinMaxValue(filter: effect, customField: "temperature")
            let sliderTintValue = filterModel.groupFilter.getMinMaxValue(filter: effect, customField: "tint")
            temperatureSlider.minimumValue = sliderTemperatureValue.min
            temperatureSlider.maximumValue = sliderTemperatureValue.max
            tintSlider.minimumValue = sliderTintValue.min
            tintSlider.maximumValue = sliderTintValue.max

            temperatureSlider.value = Float(filterModel.groupFilter.getValue(effect: effect, customField: "temperature"))
            temperatureLabel.text = "\(filterModel.groupFilter.getValue(effect: effect, customField: "temperature"))"
            tintSlider.value = Float(filterModel.groupFilter.getValue(effect: effect, customField: "tint"))
            tintLabel.text = "\(filterModel.groupFilter.getValue(effect: effect, customField: "tint"))"
        } else {
            whiteBalanceView.isHidden = true
            let sliderValue = filterModel.groupFilter.getMinMaxValue(filter: effect)
            sliderOutlet.minimumValue = sliderValue.min
            sliderOutlet.maximumValue = sliderValue.max

            sliderOutlet.value = Float(filterModel.groupFilter.getValue(effect: effect))
            valueLabel.text = "\(filterModel.groupFilter.getValue(effect: effect))"
        }
        filterSettingTopIcon.image = effect.getImage()
        effectNameLabel.text = effect.getText()
        filterSettingTopViewBottomConstraints.constant = 0
        bottomViewTopConstraints.constant = 0
        currentFilter = effect

        beforeValue = sliderOutlet.value
        beforeTint = tintSlider.value
        beforeTemperature = temperatureSlider.value

        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
