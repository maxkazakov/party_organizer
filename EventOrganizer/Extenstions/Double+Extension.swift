//
//  Double+Extension.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 17/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

extension Double {
    func formatCurrency(showZero: Bool = true) -> String {
        guard self > 0.1 else {
            return showZero ? "0" : ""
        }
        return String(format: "%.0f", self)
    }
}
