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
    
    }
    
}
