//
//  File.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 16/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class DataConverter{     
    static func convert(src: Event) throws -> EventViewData {
        guard let name = src.name else {
            throw ConvertError.error(text: "Invalid string")
        }
        
        guard let imgData = src.image as Data?, let img = UIImage(data: imgData) else {
            throw ConvertError.error(text: "Invalid image")
        }
        
        
        return EventViewData(name: name, image: img)
    }
}
