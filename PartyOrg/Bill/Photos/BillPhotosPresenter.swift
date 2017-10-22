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
    
    
    var dataProvider: DataCacheStorage!
    
    private var billImages = [BillImage]()
    var photos = [MediaPickerItem]()
    
    
    
    private func makeBillImage(from: MediaPickerItem, completion: @escaping (BillImage) -> Void) {
        from.image.fullResolutionImageData { data in
            guard let data = data else {
                fatalError("Cannot get image data from MediaPickerItem object")
            }
            let url = ImageProvider.shared.save(data: data)
            CoreDataManager.instance.performInMainContext { context in
                let billImage = BillImage(within: context)
                billImage.bill = self.dataProvider.currentBill
                billImage.imagePath = url.absoluteString
                billImage.identifier = ""
                completion(billImage)
            }
        }
    }
    
    
    
    func add(items: [MediaPickerItem], startIndex: Int) {
        for item in items {
            makeBillImage(from: item) { billImage in
                self.billImages.append(billImage)
                self.photos.append(item)
            }
        }
    }
    
    
    
    func remove(index: Int?) {
        guard let index = index else {
            return
        }
        CoreDataManager.instance.performInMainContext { context in
            self.photos.remove(at: index)
            let billImage = self.billImages.remove(at: index)
            ImageProvider.shared.delete(url: URL(string: billImage.imagePath))
            context.delete(billImage)
        }
    }
    
    
    
    
    func update(item: MediaPickerItem, index: Int?) {
        guard let index = index else {
            return
        }
        photos[index] = item
        let imagePath = billImages[index].imagePath
        item.image.fullResolutionImageData { data in
            guard let data = data else {
                fatalError("Cannot get image data from MediaPickerItem object")
            }
            ImageProvider.shared.save(data: data, toPath: URL(string: imagePath))
        }
    }
    
    
    
    
    
    func load() {
        let predicate = NSPredicate(format: "bill == %@", argumentArray: [self.dataProvider.currentBill!])
        billImages = CoreDataManager.instance.fetchObjects(predicate: predicate)
        photos = billImages.map { image in
            guard let imagePath = URL(string: image.imagePath)?.path else {
                fatalError("Error while trying convert absolute path to path")
            }
            let source = LocalImageSource(path: imagePath)
            return MediaPickerItem(image: source, source: .photoLibrary)
        }       
    }

    
    

}
