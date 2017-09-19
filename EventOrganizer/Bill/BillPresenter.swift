//
//  BillPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 30/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


class BillPresenter{
    
    var dataProvider: DataCacheStorage!
    var fetchConroller: NSFetchedResultsController<MemberInBill>!
    
    deinit {
        dataProvider.resetBill()
    }
    
    lazy var bill: Bill = {
        if let bill = self.dataProvider.currentBill{
            return bill
        }
        
        let bill = Bill(within: CoreDataManager.instance.managedObjectContext)
        bill.dateCreated = Date()
        
        return bill
    }()
    
    func getBillViewData() -> BillViewData {
        return DataConverter.convert(src: bill)
    }
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(dataProvider: DataCacheStorage){
        self.dataProvider = dataProvider
        self.dataProvider.currentBill = bill
        self.fetchConroller = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: NSPredicate(format: "bill == %@", argumentArray: [bill]))
        
        do {
            try fetchConroller.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    func getMemberInBillViewData(indexPath: IndexPath) -> MemberInBillViewData{
        let memInBill = fetchConroller.object(at: indexPath)
        return DataConverter.convert(src: memInBill)
    }
    
    func getMemberInBill(indexPath: IndexPath) -> MemberInBill{
        let memInBill = fetchConroller.object(at: indexPath)
        return memInBill
    }
    
    func getMemberInBillCount() -> Int {
        if let sections = fetchConroller.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
       
    func delete(indexPath: IndexPath){
        let memInBill = fetchConroller.object(at: indexPath)
        CoreDataManager.instance.managedObjectContext.delete(memInBill)
    }
    
    func update(indexPath: IndexPath, debt: Double){
        let memInBill = fetchConroller.object(at: indexPath)
        memInBill.sum = debt
    }

    
    func save(billdata: BillViewData){
        
        CoreDataManager.instance.saveContext{
            [unowned self] in
            guard let event = self.dataProvider.currentEvent else{
                fatalError("Current event is nil")
            }
            
            self.bill.event = self.dataProvider.currentEvent!
            self.bill.name = billdata.name
            self.bill.cost = billdata.cost
            event.addToBills(self.bill)
        }
        
    }
    
}
