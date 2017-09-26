//
//  BillImages+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


@objc(BillImage)
public class BillImage: NSManagedObject, EntityBase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BillImage> {
        return NSFetchRequest<BillImage>(entityName: "BillImages")
    }
    
    @NSManaged public var identifier: String
    @NSManaged public var imagePath: String
    @NSManaged public var bill: Bill?

}
