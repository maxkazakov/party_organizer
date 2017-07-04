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
    
    var dataProvider: DataProvider!
    var fetchConroller: NSFetchedResultsController<Bill>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(dataProvider: DataProvider){
        self.dataProvider = dataProvider
        self.fetchConroller = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: NSPredicate(format: "event == %@", argumentArray: [dataProvider.currentEvent!]))
        
        do {
            try fetchConroller.performFetch()
        }
        catch {
            print(error)
        }
    }

    
    func getBill(indexPath: IndexPath) -> Bill{
        let bill = fetchConroller.object(at: indexPath)
        return bill
    }
    
    func getBillsCount() -> Int {
        if let sections = fetchConroller.sections {
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
        CoreDataManager.instance.saveContext{
            [unowned self] in
            let bill = self.fetchConroller.object(at: indexPath)
            CoreDataManager.instance.managedObjectContext.delete(bill)
        }
    }
    
    func selectRow(_ indexPath: IndexPath){
        dataProvider.currentBill = fetchConroller.object(at: indexPath)
    }
    
}
