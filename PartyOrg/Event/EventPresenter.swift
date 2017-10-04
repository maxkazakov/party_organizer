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
        event.date = Date()
        return event
    }
    
    
    
    func saveEvent(name: String, image: UIImage?) {
        let event = self.ensureEvent()
              
        CoreDataManager.instance.saveContext { context in
            event.imagePath = image.map { image in
                var path = getDocumentsDirectory()
                path.appendPathComponent(UUID().uuidString)
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        try UIImageJPEGRepresentation(image, 1.0)?.write(to: path)
                    }
                    catch {
                        fatalError("Error while saving event image. \(error)")
                    }
                }
                
                event.image = image
                return path.path
            }
            
            event.name = name
        }
    }
}
