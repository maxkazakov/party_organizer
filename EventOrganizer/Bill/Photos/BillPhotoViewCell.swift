//
//  BillPhotoViewCell.swift
//  EventOrganizer
//
//  Created by Максим Казаков on 21/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Paparazzo

class BillPhotoViewCell: UICollectionViewCell {
    static let identifier = String(describing: BillPhotoViewCell.self)
    
    @IBOutlet weak var photo: UIImageView!
    
    
    func setup(_ item: MediaPickerItem) {
        photo.layer.masksToBounds = true
        photo.layer.cornerRadius = 5
        photo.layer.borderWidth = 1
        
        photo.setImage(fromSource: item.image)
    }
}
