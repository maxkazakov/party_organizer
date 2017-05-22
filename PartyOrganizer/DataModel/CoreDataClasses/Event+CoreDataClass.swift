//
//  Event+CoreDataClass.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData

@objc(Event)

public class Event: NSManagedObject, EntityBase {

    func getImage() -> UIImage?{
        guard let imgData = self.image as Data?, let img = UIImage(data: imgData) else{
            return nil
        }
        return img
    }
}
