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
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var eventImage: ImageProviderView!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        setupStyle()
        
        
        // Initialization code
        
        eventImage.layer.cornerRadius = heightConstraint.constant / 2
        eventImage.layer.masksToBounds = false
        eventImage.clipsToBounds = true
        eventImage.set(placeholder: #imageLiteral(resourceName: "DefaultEventImage"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(data: EventViewData){
        name.text = data.name
        eventImage.set(url: data.imageUrl)
        budget.text = "Budget: ".tr() + data.budget.formatCurrency()
    }
    
}
