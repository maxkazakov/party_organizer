//
//  BillPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 30/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class BillPresenter{
    
    var event: Event?
    var bill: Bill?
    var membersInBill: [MemberInBill]?
    
    func getBillViewData() -> BillViewData? {
        guard let bill = self.bill else{
            return nil
        }
        
        return DataConverter.convert(src: bill)
        
    }
    
    func save(billdata: BillViewData){
        if (self.bill == nil){
            self.bill = Bill(within: CoreDataManager.instance.managedObjectContext)
            self.bill?.dateCreated = Date()
        }
        
        guard let b = self.bill else{
            return
        }
        b.name = billdata.name
        b.cost = billdata.cost
        self.event?.addToBills(b)
        
        CoreDataManager.instance.saveContext()
    }
    
}
