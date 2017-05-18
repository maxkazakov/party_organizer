//
//  EventListPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData

enum ConvertError: Error{
    case error (text: String)
}

class EventTablePresenter{
    
    weak var view: EventTableViewController!
    
    var fetchConroller: NSFetchedResultsController<Event>
    
    init(view: EventTableViewController){
        self.view = view
        fetchConroller = CoreDataManager.instance.fetchedResultsController()        
        do {
            try fetchConroller.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    func getEventViewData(indexPath: IndexPath) -> EventViewData{
        let e = fetchConroller.object(at: indexPath)
        do {
            return try DataConverter.convert(src: e)
        }
        catch{
            fatalError()
        }
    }
    
    func getEvent(indexPath: IndexPath) -> Event{
        return fetchConroller.object(at: indexPath)        
    }
    
    func getEventsCount()  -> Int {
        if let sections = fetchConroller.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
}
