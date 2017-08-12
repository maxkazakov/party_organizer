//
//  EventPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit



class EventPresenter{
       
    var dataProvider: DataCacheStorage!
    
    func getEventViewData() -> EventViewData?{
        guard let e = self.dataProvider.currentEvent else{
            return nil
        }
        
        return try? DataConverter.convert(src: e)
    }
    
    func saveEvent(name: String, image: UIImage) {
        
        CoreDataManager.instance.saveContext{
            var e = self.dataProvider.currentEvent
            if e == nil{
                e = Event(within: CoreDataManager.instance.managedObjectContext)
                e!.dateCreated = Date()
            }
            
            e!.name = name
            e!.image = image.getJPEGData(withQuality: UIImage.JPEGQuality.lowest) as NSData?
        }
    }
}
