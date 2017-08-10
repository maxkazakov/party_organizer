//
//  BillTableViewCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 31/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
  
    static let identifier = String(describing: BillTableViewCell.self)
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var memCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func setData(name: String, cost: Double, memCount: Int){
        self.name.text = name
        self.cost.text = "Cost: ".localize() + Helper.formatCurrency(value: cost)
        self.memCount.text = "Members: ".localize() + String(format: "%d", memCount)
    }
}
