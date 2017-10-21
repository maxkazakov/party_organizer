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
        return 1
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count + 1
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoButtonViewCell.identifier, for: indexPath) as! AddPhotoButtonViewCell
            
            cell.setup {
                self.openPhotoSelectionController(selected: nil)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BillPhotoViewCell.identifier, for: indexPath) as! BillPhotoViewCell
            cell.setup(presenter.photos[indexPath.row - 1])
            return cell
        }
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = presenter.photos[indexPath.row - 1]
        openPhotoSelectionController(selected: item)
    }
    
    
    
    func openPhotoSelectionController(selected item: MediaPickerItem?) {
        var theme = PaparazzoUITheme()
        theme.shutterButtonDisabledColor = Colors.barAccent
        let factory = Paparazzo.AssemblyFactory(theme: theme)
        let assembly = factory.mediaPickerAssembly()
    
        
        let data = MediaPickerData(items: self.presenter.photos, selectedItem: item, maxItemsCount: 5, cropEnabled: true, cropCanvasSize: CGSize(width: 1000, height: 1000))
        
        let viewController = assembly.module(data: data) { module in
            module.setAccessDeniedTitle("CAMERA_REQUEST_MESSAGE".tr())
            module.setAccessDeniedMessage("")
            module.setCropMode(.normal)
            
            module.onCancel = {
                self.collectionView?.reloadData()
                module.dismissModule()
                UIApplication.shared.setStatusBarHidden(false, with: .fade)
            }
            module.onItemsAdd = { items in
                self.presenter.add(items: items.0)
            }
            module.onItemRemove = { item in
                self.presenter.remove(item: item.0)
            }
//            module.setContinueButtonEnabled(true)
        }
        let mediaPickerNavigatorController = UINavigationController(rootViewController: viewController)
        self.present(mediaPickerNavigatorController, animated: true, completion: nil)
    }

}
