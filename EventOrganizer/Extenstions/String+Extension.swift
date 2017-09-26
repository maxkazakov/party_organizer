//
//  String.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 09/08/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

extension String{
    
    func tr() -> String{
        return NSLocalizedString(self, comment: "")
    }
    
    
    func toCurrency() -> Double {
        let value = Double(self) ?? 0.0
        return value < 0.1 ? 0.0 : value
    }
}
