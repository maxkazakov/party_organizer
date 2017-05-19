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
    
    func getImage(withQuality quality: JPEGQuality) -> UIImage? {
        let data = UIImageJPEGRepresentation(self, quality.rawValue)
        return UIImage(data: data!)
    }
    
}
