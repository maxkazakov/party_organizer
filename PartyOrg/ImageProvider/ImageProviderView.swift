//
//  ImageProviderView.swift
//  PartyOrg
//
//  Created by Максим Казаков on 18/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class ImageProviderView: UIImageView {
    
    func set(placeholder: UIImage) {
        self.image = placeholder
    }    
    
    
    func set(url: URL?) {
        guard let url = url else {
            return
        }
        ImageProvider.shared.load (url: url) { error, image in
            if let error = error {
                print(error)
                return
            }
            self.image = image
        }
    }
}
