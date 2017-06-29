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
    
    var dataProvider: DataProvider!
    var fetchConroller: NSFetchedResultsController<MemberInBill>!
    
    lazy var bill: Bill = {
        if let bill = self.dataProvider.currentBill{
            return bill
        }
        
        let bill = Bill(within: CoreDataManager.instance.managedObjectContext)
        bill.dateCreated = Date()

        return bill
    }()
    
    func getBillViewData() -> BillViewData? {
        return DataConverter.convert(src: bill)
    }
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(dataProvider: DataProvider){
        self.dataProvider = dataProvider
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
        do {
            return try DataConverter.convert(src: memInBill)
        }
        catch{
            fatalError()
        }
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
    
    func insert(memberId: NSManagedObjectID){
        guard let member = CoreDataManager.instance.managedObjectContext.registeredObject(for: memberId) as? Member else{
            return
        }

        let memInBill = MemberInBill(within: CoreDataManager.instance.managedObjectContext)
        member.addToMemInBills(memInBill)
        bill.addToMemInBills(memInBill)
    }
    
    func delete(indexPath: IndexPath){
        let memInBill = fetchConroller.object(at: indexPath)
        CoreDataManager.instance.managedObjectContext.delete(memInBill)
    }
    
    func update(indexPath: IndexPath, memberInBillInfo: MemberInBillViewData){
        let memInBill = fetchConroller.object(at: indexPath)
        memInBill.sum = memberInBillInfo.debt
    }

    
    func save(billdata: BillViewData){
        guard let event = dataProvider.currentEvent else{
            fatalError("Current event is nil")
        }
        
        bill.name = billdata.name
        bill.cost = billdata.cost
        event.addToBills(bill)
        
        CoreDataManager.instance.saveContext()
    }
    
}
