//
//  EventInfoBarTitle.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventInfoBarTitle: UIView {    
    
    let titleView = UILabel()
    let imageView = ImageProviderView()
    
    override init (frame: CGRect) {
        super.init(frame: frame)        
        
        self.addSubview(self.titleView)
        self.addSubview(self.imageView)
        
        setupImageView()
        setupTitleView()
    }
    
    
    
    func setupTitleView() {
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let trailConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -8)
        let leadConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 3)
        let alignY = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        titleView.font = UIFont.systemFont(ofSize: 12)
        
        self.addConstraints([trailConstraint, alignY, leadConstraint])
    }
    
    
    
    func setupImageView() {
        self.imageView.set(placeholder: #imageLiteral(resourceName: "DefaultEventImage"))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 5)
        let alignY = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 0.85, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
        
        self.addConstraints([leadConstraint, alignY, heightConstraint, widthConstraint])
        
        self.imageView.layer.borderWidth = 0.0
        
        self.imageView.layer.masksToBounds = false
        self.imageView.clipsToBounds = true;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(title: String, imageUrl: URL?) {
        self.titleView.text = title
        self.titleView.textColor = Colors.barText
        self.imageView.set(url: imageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = imageView.frame.width / 2;
    }
}
