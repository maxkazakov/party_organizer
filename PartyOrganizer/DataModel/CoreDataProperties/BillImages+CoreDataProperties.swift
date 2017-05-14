//
//  BillImages+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension BillImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BillImages> {
        return NSFetchRequest<BillImages>(entityName: "BillImages")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var bill: Bill?

}
