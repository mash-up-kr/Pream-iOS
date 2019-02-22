//
//  FilterCollectionViewController.swift
//  pream
//
//  Created by Suji Kim on 26/01/2019.
//  Copyright © 2019 jercy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterCollectionViewCell"

protocol FilterCollectionViewDelegate: class {
    func filterSelected(model: FilterModel)
}

class FilterCollectionViewController: UICollectionViewController {
    let dummy: FilterModelDummy = {
        let dummy = FilterModelDummy()
        dummy.makeDummy()
        return dummy
    }()
    //삭제 필

    weak var delegate: FilterCollectionViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dummy.dummyFilters.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilterCollectionViewCell else {
            return UICollectionViewCell()
        }

        // Configure the cell
        if indexPath.item == 0 {
            cell.firstCellConfig()
        } else {
            cell.config()
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "FilterList", bundle: nil)
        let feedMainNavigationController = storyboard.instantiateViewController(withIdentifier: "FilterListMainNavigationController")
        if indexPath.item == 0 {
            present(feedMainNavigationController, animated: true, completion: nil)
        } else {
            // TODO: - 수정필요
            delegate?.filterSelected(model: dummy.dummyFilters[indexPath.item - 1])
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
