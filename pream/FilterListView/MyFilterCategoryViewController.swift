//
//  MyFilterCategoryViewController.swift
//  pream
//
//  Created by Suji Kim on 06/02/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

class MyFilterCategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    let cellReuseIdentifier = "MyFilterCategoryCollectionViewCell"
    var cellSpacing: CGFloat = 20
    var targetSize = CGSize.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        initView()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension MyFilterCategoryViewController {
    func initView() {
        let categoryWidth = view.frame.width - (cellSpacing * 2)
        let categoryHeight = categoryWidth * (110 / 335)
        targetSize = CGSize(width: categoryWidth, height: categoryHeight)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = targetSize
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing - 10
        collectionView.collectionViewLayout = layout
    }
}

extension MyFilterCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MyFilterCategoryCollectionViewCell

        cell.config()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
