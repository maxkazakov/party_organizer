//
//  DataProvider.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 25/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

// Singletone data object

class DataCacheStorage{
    
    var currentEvent: Event?
    
    var currentMember: Member?
    
    var currentBill: Bill?
    
    func resetEvent(){
        self.currentEvent = nil
    }
    
    func resetMember(){
        if let mem = currentMember, mem.hasChanges{
            CoreDataManager.instance.managedObjectContext.rollback()
        }
        self.currentMember = nil
    }
    
    func resetBill(){
        if let bill = currentBill, bill.hasChanges {
            CoreDataManager.instance.managedObjectContext.rollback()
        }
        self.currentBill = nil
    }
    
}
