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
    
    func getEventViewData() -> EventViewData? {
        guard let e = self.dataProvider.currentEvent else{
            return nil
        }        
        return EventViewData.from(event: e)
    }
    
    
    
    func ensureEvent() -> Event {
        if let event = self.dataProvider.currentEvent {
            return event
        }
        let event = Event(within: CoreDataManager.instance.managedObjectContext)
        event.dateCreated = Date()
        event.date = Date()
        return event
    }
    
    
    
    func saveEvent(name: String, image: UIImage?) {
        let event = self.ensureEvent()
              
        CoreDataManager.instance.saveContext { context in
            event.imagePath = image.map { image in
                
                if let oldPath = event.imagePath {
                    ImageProvider.shared.delete(url: URL(string: oldPath))
                }
                
                let path = ImageProvider.shared.save(image: image)                                
                return path.absoluteString
            }
            
            event.name = name
        }
    }
}
