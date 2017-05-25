//
//  Event+CoreDataProperties.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 25/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var bills: NSOrderedSet?
    @NSManaged public var members: NSOrderedSet?

}

// MARK: Generated accessors for bills
extension Event {

    @objc(insertObject:inBillsAtIndex:)
    @NSManaged public func insertIntoBills(_ value: Bill, at idx: Int)

    @objc(removeObjectFromBillsAtIndex:)
    @NSManaged public func removeFromBills(at idx: Int)

    @objc(insertBills:atIndexes:)
    @NSManaged public func insertIntoBills(_ values: [Bill], at indexes: NSIndexSet)

    @objc(removeBillsAtIndexes:)
    @NSManaged public func removeFromBills(at indexes: NSIndexSet)

    @objc(replaceObjectInBillsAtIndex:withObject:)
    @NSManaged public func replaceBills(at idx: Int, with value: Bill)

    @objc(replaceBillsAtIndexes:withBills:)
    @NSManaged public func replaceBills(at indexes: NSIndexSet, with values: [Bill])

    @objc(addBillsObject:)
    @NSManaged public func addToBills(_ value: Bill)

    @objc(removeBillsObject:)
    @NSManaged public func removeFromBills(_ value: Bill)

    @objc(addBills:)
    @NSManaged public func addToBills(_ values: NSOrderedSet)

    @objc(removeBills:)
    @NSManaged public func removeFromBills(_ values: NSOrderedSet)

}

// MARK: Generated accessors for members
extension Event {

    @objc(insertObject:inMembersAtIndex:)
    @NSManaged public func insertIntoMembers(_ value: Member, at idx: Int)

    @objc(removeObjectFromMembersAtIndex:)
    @NSManaged public func removeFromMembers(at idx: Int)

    @objc(insertMembers:atIndexes:)
    @NSManaged public func insertIntoMembers(_ values: [Member], at indexes: NSIndexSet)

    @objc(removeMembersAtIndexes:)
    @NSManaged public func removeFromMembers(at indexes: NSIndexSet)

    @objc(replaceObjectInMembersAtIndex:withObject:)
    @NSManaged public func replaceMembers(at idx: Int, with value: Member)

    @objc(replaceMembersAtIndexes:withMembers:)
    @NSManaged public func replaceMembers(at indexes: NSIndexSet, with values: [Member])

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSOrderedSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSOrderedSet)

}
