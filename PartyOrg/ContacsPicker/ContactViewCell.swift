//
//  ContactViewCell.swift
//  PartyOrg
//
//  Created by Максим Казаков on 09/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    static let identifier = String(describing: ContactViewCell.self)
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatarSizeConstraint.constant / 2
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }

    @IBOutlet weak var avatarSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    
    func setup(name: String, phone: String, avatar: UIImage?) {
        nameLabel.text = name
        phoneLabel.text = phone
        self.avatar.image = avatar
    }
}
