//
//  MemberTableViewCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    static let identifier = String(describing: MemberTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var debt: UILabel!
    
    func setData(name: String, debt: Double){
        self.name.text = name
        self.debt.text = "Debt: ".tr() + debt.formatCurrency()
    }

}
