//
//  AccessDeniedCell.swift
//  PartyOrg
//
//  Created by Максим Казаков on 09/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class AccessDeniedCell: UITableViewCell {
    static let identifier = String(describing: AccessDeniedCell.self)
    
    var messageLabel = UILabel()
    var settingsButton = UIButton(type: .roundedRect)
 
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageLabel)
        addSubview(settingsButton)
        
        messageLabel.text = "CONTACTS_ACCESS_DENIED_MESSAGE".tr()
        settingsButton.setTitle("SETTINGS".tr(), for: .normal)

        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let box = UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        
        messageLabel.frame.origin = box.origin
        messageLabel.frame.size = CGSize(width: box.width, height: box.height / 2)
        
        let width: CGFloat = 150
        settingsButton.frame.size = CGSize(width: width, height: 30)
        settingsButton.frame.origin = CGPoint(x: (box.width - width) / 2, y: messageLabel.frame.maxY)
    }
    
    
    
    @objc private func openSettings() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
}
