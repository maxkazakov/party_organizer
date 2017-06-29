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
        
        
        let predicate = NSPredicate(format: "%K == %@ AND NONE %K.%K == %@", argumentArray: ["event", event, "memInBills", "bill", bill])
        
        
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

    
        
}
