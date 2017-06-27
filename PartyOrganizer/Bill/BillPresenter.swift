//
//  BillPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 30/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class BillPresenter{
    
    var dataProvider: DataProvider!
    
    deinit {
        dataProvider.resetBill()
    }
    
    func getBillViewData() -> BillViewData? {
        guard let bill = dataProvider.currentBill else{
            return nil
        }
        
        return DataConverter.convert(src: bill)
    }
    
    func save(billdata: BillViewData){
        guard let event = dataProvider.currentEvent else{
            fatalError("Current event is nil")
        }
        
        var bill: Bill! = self.dataProvider.currentBill
        if (bill == nil){
            bill = Bill(within: CoreDataManager.instance.managedObjectContext)
            bill.dateCreated = Date()
       }
        
        bill.name = billdata.name
        bill.cost = billdata.cost
        event.addToBills(bill)
        
        CoreDataManager.instance.saveContext()
    }
    
}
