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

class EventTablePresenter {
    var dataProvider: DataProvider!
    
    private var fetchConroller: NSFetchedResultsController<Event>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(){
        self.fetchConroller = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)])
        
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
        let event = fetchConroller.object(at: indexPath)
        return event
    }
    
    func getEventsCount()  -> Int {
        if let sections = fetchConroller.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func delete(indexPath: IndexPath){
        let event = fetchConroller.object(at: indexPath)
        CoreDataManager.instance.managedObjectContext.delete(event)
        CoreDataManager.instance.saveContext()
    }
    
    func selectRow(_ indexPath: IndexPath){
        dataProvider.currentEvent = fetchConroller.object(at: indexPath)
    }
    
}
