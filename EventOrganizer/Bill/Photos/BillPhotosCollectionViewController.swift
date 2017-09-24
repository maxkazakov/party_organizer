//
//  BillPhotosCollectionViewController.swift
//  EventOrganizer
//
//  Created by Максим Казаков on 21/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

import Paparazzo

class BillPhotosCollectionViewController: UICollectionViewController {
    
    var presenter: BillPhotosPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.load {
            self.collectionView?.reloadData()
        }
    }

    func saveImages() {
        presenter.save()
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return presenter.photos.count + 1
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoButtonViewCell.identifier, for: indexPath) as! AddPhotoButtonViewCell
            
            cell.setup {
                let factory = Paparazzo.AssemblyFactory()
                let assembly = factory.mediaPickerAssembly()
                
                let viewController = assembly.module(items: self.presenter.photos, selectedItem: nil, maxItemsCount: 5, cropEnabled: true, cropCanvasSize: CGSize.zero) { module in
                    module.onCancel = {
                        module.dismissModule()
                    }
                    module.onItemsAdd = { items in
                        self.presenter.add(items: items)
                    }
                    module.onItemRemove = { item in                        
                        self.presenter.remove(item: item)
                    }
                    module.onFinish = { _ in
                        self.collectionView?.reloadData()
                        module.dismissModule()
                    }
                    module.setContinueButtonEnabled(true)
                }
                self.present(viewController, animated: true, completion: nil)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BillPhotoViewCell.identifier, for: indexPath) as! BillPhotoViewCell
            cell.setup(presenter.photos[indexPath.row - 1])
            return cell
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
