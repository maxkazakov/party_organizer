//
//  BillTableViewPrenester.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


class BillTablePrenester {
    
    var dataProvider: DataCacheStorage!
    var fetchController: NSFetchedResultsController<Bill>
    
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchController.delegate = delegate
    }
    
    init(dataProvider: DataCacheStorage){
        self.dataProvider = dataProvider
        self.fetchController = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: NSPredicate(format: "event == %@", argumentArray: [dataProvider.currentEvent!]))
        
        do {
            try fetchController.performFetch()
        }
        catch {
            print(error)
        }

    }

    
    func getBill(indexPath: IndexPath) -> Bill{
        let bill = fetchController.object(at: indexPath)
        return bill
    }
    
    func getBillsCount() -> Int {
        if let sections = fetchController.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func getBillViewData(indexPath: IndexPath) -> BillViewData{
        let bill = getBill(indexPath: indexPath)
        return DataConverter.convert(src: bill)
    }
    
    func delete(indexPath: IndexPath){
        CoreDataManager.instance.saveContext {[unowned self] context in             
            let bill = self.fetchController.object(at: indexPath)
            bill.deleteImages()
            context.delete(bill)
        }
    }
    
    func selectRow(_ indexPath: IndexPath) {
        dataProvider.currentBill = fetchController.object(at: indexPath)
    }
}
