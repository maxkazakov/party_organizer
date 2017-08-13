//
//  File.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 13/08/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

enum NewItemButtonType {
    case bill
    case member
}

class AddNewItemButton: UIView {
    
    private let button = UIButton()
    var callback: (() -> Void)?
    
    init(type: NewItemButtonType) {
        super.init(frame: CGRect.zero)
        
        let image: UIImage
        switch type {
        case .bill:
            image = UIImage(named: "addBill")!
        case .member:
            image = UIImage(named: "addMember")!
        }
        
        self.button.setBackgroundImage(image, for: .normal)
        self.addSubview(self.button)
        
        self.button.translatesAutoresizingMaskIntoConstraints = false
        let alignYConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.8, constant: 0)
        let alignXConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        self.addConstraints([heightConstraint, widthConstraint, alignYConstraint, alignXConstraint])
        
        button.addTarget(self, action: #selector(tapAction), for: .touchDown)
    }
    
    
    func tapAction() {
        callback?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
