//
//  EventPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit


class EventPresenter {
       
    var dataProvider: DataCacheStorage!
    
    func getEventViewData() -> EventViewData?{
        guard let e = self.dataProvider.currentEvent else{
            return nil
        }
        
        return DataConverter.convert(src: e)
    }
    
    
    
    func ensureEvent() -> Event {
        if let event = self.dataProvider.currentEvent {
            return event
        }
        let event = Event(within: CoreDataManager.instance.managedObjectContext)
        event.dateCreated = Date()
        return event
    }
    
    
    
    func saveEvent(name: String, image: UIImage?) {
        let event = self.ensureEvent()
        
        CoreDataManager.instance.saveContext {
            event.name = name
            if let img = image, let zippedImageData = img.getJPEGData(withQuality: UIImage.JPEGQuality.lowest) as? NSData  {
                event.image = zippedImageData
            }
        }
    }
}
