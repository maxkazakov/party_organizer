//
//  UIImageExtenstion.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 20/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit



extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    func getJPEGImage(withQuality quality: JPEGQuality) -> UIImage? {        
        let data = UIImageJPEGRepresentation(self, quality.rawValue)
        return UIImage(data: data!)
    }
    
    func getJPEGData(withQuality quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    
    func resize() -> UIImage
    {
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        let maxHeight: CGFloat = 300.0
        let maxWidth: CGFloat = 300.0
        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight
        let compressionQuality: CGFloat = 0.5
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if imgRatio < maxRatio
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else
            {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData!)!
        
    }
}
