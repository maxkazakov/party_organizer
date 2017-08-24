//
//  CommonHelper.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Double {
    func formatCurrency(showZero: Bool = true) -> String {
        guard self > 0.1 else {
            return showZero ? "0" : ""
        }
        return String(format: "%.0f", self)
    }
}

extension String {
    func toCurrency() -> Double {
        let value = Double(self) ?? 0.0
        return value < 0.1 ? 0.0 : value
    }
}
