//
//  EventInfoBarTitle.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventInfoBarTitle: UIView {    
    
    var titleView: UILabel!
    var imageView: UIImageView!    
    
    override init (frame: CGRect){
        super.init(frame: frame)
        self.titleView = UILabel()
        
        self.imageView = UIImageView()
        
        self.addSubview(self.titleView)
        self.addSubview(self.imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(title: String, image: UIImage?){
        self.titleView.text = title
        self.imageView.image = image
        
        self.imageView.layer.borderWidth = 0.0
        
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
        self.imageView.clipsToBounds = true;
    }
    
    func layout(){
        let rootFrame = self.frame
        let width: CGFloat = 150
        let margin: CGFloat = 3
        let imageWidth: CGFloat = rootFrame.height - margin * 2
        self.imageView.frame = CGRect(x: margin, y: margin, width: imageWidth, height: imageWidth)
        
        imageView.contentMode = .scaleToFill
        
        let titleWidth = width - imageWidth + margin * 2 - 10
        self.titleView.frame = CGRect(x: imageWidth + margin * 2, y: 0, width: titleWidth, height: rootFrame.height)
        self.titleView.font = UIFont.systemFont(ofSize: 12)
        
    }

}
