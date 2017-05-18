//
//  EventPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit


class EventPresenter{
    
    weak var view: EventViewController!
    var event: Event?
    
    init(view: EventViewController){
        self.view = view
    }
    
    func getEventViewData() -> EventViewData?{
        guard let e = self.event else{
            return nil
        }
        
        return try? DataConverter.convert(src: e)
    }
    
    func changeEvent(name: String, image: UIImage) {
        if (self.event == nil){
            self.event = Event(within: CoreDataManager.instance.managedObjectContext)
        }
        event!.name = name
        event!.image = UIImagePNGRepresentation(image) as NSData?
        CoreDataManager.instance.saveContext()
    }
}
