    //
//  MemberSelectPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 29/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

import CoreData

class MemberSelectPrenester {
    
    var dataProvider: DataProvider!
    
    private var fetchConroller: NSFetchedResultsController<Member>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(dataProvider: DataProvider){
        self.dataProvider = dataProvider
        
        let bill = self.dataProvider.currentBill!
        let event = self.dataProvider.currentEvent!
        
       
        let predicate = NSPredicate(format: "%K == %@ AND (%K.@count = 0 OR SUBQUERY(%K, $m, $m.%K == %@).@count == 0)", argumentArray: ["event", event, "memInBills", "memInBills", "bill", bill])
        
        
        self.fetchConroller = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: predicate)
        
        do {
            try fetchConroller.performFetch()
            
        }
        catch {
            print(error)
        }
    }
    
    func getMemberViewData(indexPath: IndexPath) -> MemberViewData{
        let m = fetchConroller.object(at: indexPath)
        return DataConverter.convert(src: m)
        
    }
    
    func getMember(indexPath: IndexPath) -> Member{
        let member = fetchConroller.object(at: indexPath)
        return member
    }
    
    func getMembersCount()  -> Int {
        if let sections = fetchConroller.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func select(_ indices: [IndexPath]){
        for idx in indices{
            let member = getMember(indexPath: idx)
            let memInBill = MemberInBill(within: CoreDataManager.instance.managedObjectContext)
            memInBill.dateCreated = Date()
            let bill = self.dataProvider.currentBill!
            
            bill.addToMemInBills(memInBill)
            member.addToMemInBills(memInBill)
        }
    }

    
        
}
