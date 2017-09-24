//
//  BillPhotosPresenter.swift
//  EventOrganizer
//
//  Created by Максим Казаков on 24/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData
import Paparazzo
import ImageSource



class BillPhotosPresenter {
    
    struct Photo {
        let uid: String
        let photo: MediaPickerItem
    }
    
    var dataProvider: DataCacheStorage!
    
    var billImages = [String: BillImage]()
    
    private var _photos = [Photo]()
    var photos = [MediaPickerItem]()
    
    var toRemove = [String]()
    
    func add(items: [MediaPickerItem]) {
        items.forEach{ self.addPhoto(photo: $0) }
    }
    
    func addPhoto(uid: String = UUID().uuidString, photo: MediaPickerItem) {
        _photos.append(Photo(uid: uid, photo: photo))
        photos.append(photo)
    }
    
        
    func remove(item: MediaPickerItem) {
        if let index = photos.index(of: item) {
            photos.remove(at: index)
            _photos.remove(at: index)
        }
    }
    
    
    
    func load(completion: () -> ()) {
        let predicate = NSPredicate(format: "bill == %@", argumentArray: [self.dataProvider.currentBill!])
        let images: [BillImage] = CoreDataManager.instance.fetchObjects(predicate: predicate)
        for image in images {
            billImages[image.identifier] = image
            let source = LocalImageSource(path: image.imagePath)
            let item = MediaPickerItem(image: source, source: .photoLibrary)
            addPhoto(uid: image.identifier, photo: item)
        }
        completion()
    }

    
    func save() {
        
        for photo in self._photos {
            if let _ = self.billImages[photo.uid] {
                continue
            }
            photo.photo.image.fullResolutionImageData { data in
                guard let data = data else {
                    return
                }
                var path = getDocumentsDirectory()
                path.appendPathComponent(photo.uid)
                do {
                    try data.write(to: path)
                    CoreDataManager.instance.saveContext { context in
                        let billImage = BillImage(within: context)
                        
                        billImage.bill = self.dataProvider.currentBill
                        billImage.imagePath = path.path
                        billImage.identifier = photo.uid
                    }
                }
                catch {
                    print("error : \(error)" )
                }
            }
            
        }
        
    }
    

}
