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
    
    private var fetchController: NSFetchedResultsController<Event>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchController.delegate = delegate
    }
    
    init(){
        self.fetchController = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)])
        
        do {
            try fetchController.performFetch()
            
        }
        catch {
            print(error)
        }
    }
    
    func getEventViewData(indexPath: IndexPath) -> EventViewData{
        let e = fetchController.object(at: indexPath)
        do {
            return try DataConverter.convert(src: e)
        }
        catch{
            fatalError()
        }
    }
    
    func getEvent(indexPath: IndexPath) -> Event{
        let event = fetchController.object(at: indexPath)
        return event
    }
    
    func getEventsCount()  -> Int {
        if let sections = fetchController.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func delete(indexPath: IndexPath){
        CoreDataManager.instance.saveContext(){
            [unowned self] in
            let event = self.fetchController.object(at: indexPath)
            CoreDataManager.instance.managedObjectContext.delete(event)
        }
        
    }
    
    func selectRow(_ indexPath: IndexPath){
        dataProvider.currentEvent = fetchController.object(at: indexPath)
    }
    
}
