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
    
    private static let iconSize: CGFloat = 50
    
    private let button = UIButton()
    private let label = UILabel()
    
    var callback: (() -> Void)?
    
    
    
    init(type: NewItemButtonType, accentText: String = "items") {
        super.init(frame: CGRect.zero)
        
        let image: UIImage
        switch type {
        case .bill:
            image = UIImage(named: "addBill")!
        case .member:
            image = UIImage(named: "addMember")!
        }
        
        self.button.setBackgroundImage(image, for: .normal)
        self.addSubview(button)
        self.addSubview(label)
        
        layoutButton()
        layoutLabel()
        
        
        let attributedString = NSMutableAttributedString(string: "Here are no any ".tr())
        let coloredText = NSAttributedString(string: accentText, attributes: [NSForegroundColorAttributeName: Colors.sectionButton])
        let secondLine = NSAttributedString(string: ".\nTap to add a new one".tr())
        
        attributedString.append(coloredText)
        attributedString.append(secondLine)
        label.attributedText = attributedString
        
        button.addTarget(self, action: #selector(tapAction), for: .touchDown)
    }
    
    
    
    func layoutButton() {
        self.button.translatesAutoresizingMaskIntoConstraints = false
        let alignYConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let alignXConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AddNewItemButton.iconSize)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: AddNewItemButton.iconSize)
        
        self.addConstraints([heightConstraint, widthConstraint, alignYConstraint, alignXConstraint])
    }
    
    func layoutLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Colors.grayText
        label.numberOfLines = 2
        let alignYConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0)
        let alignXConstraint = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        self.addConstraints([heightConstraint, alignYConstraint, alignXConstraint])
    }
    
    @objc func tapAction() {
        callback?()
    }
    
    var requiredHeight: CGFloat {
        return 200
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
