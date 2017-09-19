//
//  DummyViewCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 17/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class DummyViewCell: UITableViewCell {
    
    static let identifier = String(describing: DummyViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var view: UIView!
}
