//
//  Event+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: NSData?
    @NSManaged public var bills: NSSet?
    @NSManaged public var members: NSSet?

}

// MARK: Generated accessors for bills
extension Event {

    @objc(addBillsObject:)
    @NSManaged public func addToBills(_ value: Bill)

    @objc(removeBillsObject:)
    @NSManaged public func removeFromBills(_ value: Bill)

    @objc(addBills:)
    @NSManaged public func addToBills(_ values: NSSet)

    @objc(removeBills:)
    @NSManaged public func removeFromBills(_ values: NSSet)

}

// MARK: Generated accessors for members
extension Event {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}
