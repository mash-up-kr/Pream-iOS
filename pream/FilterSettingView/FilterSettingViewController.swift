//
//  FilterSettingViewController.swift
//  pream
//
//  Created by 이재성 on 19/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class FilterSettingViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!

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
}

extension FilterSettingViewController: LibraryDelegate {
    func selectImage(data: Data?) {
        if let data = data {
            let image = UIImage(data: data)
            previewImageView.image = image
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
}
