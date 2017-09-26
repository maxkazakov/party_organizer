//
//  EventTableViewCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var name: UILabel!    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var budget: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        setupStyle()
        
        // Initialization code
        img.layer.cornerRadius = heightConstraint.constant / 2
        img.layer.masksToBounds = false
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data: EventViewData){
        self.name.text = data.name
        self.img.image = data.image
        self.budget.text = "Budget: ".tr() + data.budget.formatCurrency()
    }
    
}
