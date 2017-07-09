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
        img.layer.cornerRadius = 25
        img.layer.masksToBounds = false
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        img.layer.borderWidth = 1.0

        // Configure the view for the selected state
    }
    
    func setData(name: String, img: UIImage, budget: Double){
        self.name.text = name
        self.img.image = img
        self.budget.text = String(format: "%.2f", budget)
    }

}
