//
//  MemberCheckableViewCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 01/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class MemberCheckableViewCell: UITableViewCell {
   
    static let identifier = String(describing: MemberCheckableViewCell.self)
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
