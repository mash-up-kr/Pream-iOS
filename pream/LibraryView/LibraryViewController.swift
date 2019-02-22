//
//  LibraryViewController.swift
//  pream
//
//  Created by Gaon Kim on 23/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit
import Photos

protocol LibraryDelegate: class {
    func selectImage(data: Data?)
}

class LibraryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let cellReuseIdentifier = "ImagePickerCollectionViewCell"
    let columnCount: Int = 3
    let cellSpacing: CGFloat = 3
    var fetchResult: PHFetchResult<PHAsset>?
    var imageManager = PHCachingImageManager()
    var targetSize = CGSize.zero
    weak var delegate: LibraryDelegate?

    @IBAction private func backButtonAction(_ sendder: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        loadPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension LibraryViewController {
    func initView() {
        let imgWidth = (view.frame.width - (cellSpacing * (CGFloat(columnCount) - 1))) / CGFloat(columnCount)
        targetSize = CGSize(width: imgWidth, height: imgWidth)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        collectionView.collectionViewLayout = layout

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }

    func loadPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchResult = PHAsset.fetchAssets(with: .image, options: options)
    }
}

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        guard let fetchResult = fetchResult else { return cell }
        let photoAsset = fetchResult.object(at: indexPath.item)
        imageManager.requestImage(for: photoAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ -> Void in
            let imageView = UIImageView(image: image)
            imageView.frame.size = cell.frame.size
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fetchResult = fetchResult else { return }
        let photoAsset = fetchResult.object(at: indexPath.item)
        imageManager.requestImageData(for: photoAsset, options: nil) { [weak self] data, _, _, _ in
            self?.delegate?.selectImage(data: data)
        }
    }
}
