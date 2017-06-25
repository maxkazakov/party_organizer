//
//  EventPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit



class EventPresenter{
       
    var event: Event?
    
    func getEventViewData() -> EventViewData?{
        guard let e = self.event else{
            return nil
        }
        
        return try? DataConverter.convert(src: e)
    }
    
    func saveEvent(name: String, image: UIImage) {
        if (self.event == nil){
            self.event = Event(within: CoreDataManager.instance.managedObjectContext)
            self.event?.dateCreated = Date()
        }
        
        guard let e = self.event else{
            return
        }
        e.name = name
        e.image = image.getJPEGData(withQuality: UIImage.JPEGQuality.lowest) as NSData?
        
        CoreDataManager.instance.saveContext()
    }
}
