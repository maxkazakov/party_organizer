//
//  EmptyTableMessageView.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 21/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EmptyTableMessageView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var label: UILabel!
    var label_with_action: UILabel?
    
    var tap_callback: (() -> Void)?
       
    init(_ entityName: String, showAddAction: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        super.isOpaque = false
        label = UILabel()
        label.text = "\(entityName) list is empty"
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "Add new", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,                                                                                      NSForegroundColorAttributeName: UIColor(rgb: 0x7283ff)])
        
        if showAddAction{
            label_with_action = UILabel()
            label_with_action!.attributedText = attributedText
            label_with_action!.textAlignment = .center
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            label_with_action!.isUserInteractionEnabled = true
            label_with_action!.addGestureRecognizer(tap)
            addSubview(label_with_action!)
        }
        addSubview(label)
        
    }
    
    func layout(){
        let rect = self.frame
        let height: CGFloat = 20
        
        label.frame = CGRect(x: 0, y: 0, width: rect.width, height: height)
        label.center = CGPoint(x: rect.width / 2, y: rect.height / 2 - height)
        
        label_with_action?.frame = CGRect(x: 0, y: 0, width: rect.width, height: height)
        label_with_action?.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
    }
    
    func tapAction(_ sender: UIGestureRecognizer){
        tap_callback?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

