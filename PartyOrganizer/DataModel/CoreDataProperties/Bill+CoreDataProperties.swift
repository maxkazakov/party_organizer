//
//  Bill+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension Bill {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bill> {
        return NSFetchRequest<Bill>(entityName: "Bill")
    }

    @NSManaged public var cost: Double
    @NSManaged public var name: String?
    @NSManaged public var event: Event?
    @NSManaged public var memInBills: NSSet?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for memInBills
extension Bill {

    @objc(addMemInBillsObject:)
    @NSManaged public func addToMemInBills(_ value: MemberInBill)

    @objc(removeMemInBillsObject:)
    @NSManaged public func removeFromMemInBills(_ value: MemberInBill)

    @objc(addMemInBills:)
    @NSManaged public func addToMemInBills(_ values: NSSet)

    @objc(removeMemInBills:)
    @NSManaged public func removeFromMemInBills(_ values: NSSet)

}

// MARK: Generated accessors for images
extension Bill {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: BillImages)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: BillImages)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
