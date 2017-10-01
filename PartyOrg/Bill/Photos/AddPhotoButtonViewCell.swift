//
//  AddPhotoButtonViewCell.swift
//  EventOrganizer
//
//  Created by Максим Казаков on 23/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class AddPhotoButtonViewCell: UICollectionViewCell {
    static let identifier = String(describing: AddPhotoButtonViewCell.self)
    
    private var callback: (() -> ())?
    
    @IBAction func addButtonAction(_ sender: Any) {
        callback?()
    }
    
    func setup(callback: @escaping () -> ()) {
        self.callback = callback
    }
}
