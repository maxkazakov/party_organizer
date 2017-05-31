//
//  BillTableViewPrenester.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation


class BillTablePrenester {
    var event: Event!
    
    func getBill(index: Int) -> Bill{
        guard let bills = event.bills else{
            fatalError()
        }
        
        guard index >= 0 && index < bills.count else{
            fatalError()
        }
        
        return bills[index]
    }
    
    func getBillsCount() -> Int {
        guard let bills = event.bills else{
            return 0
        }
        return bills.count
    }
    
    func getBillViewData(index: Int) -> BillViewData{
        let bill = getBill(index: index)
        return DataConverter.convert(src: bill)
    }
}
