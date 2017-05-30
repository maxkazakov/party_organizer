//
//  Member+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var event: Event?
    @NSManaged public var memInBills: [MemberInBill]?
    @NSManaged public var dateCreated: Date?

}

// MARK: Generated accessors for memInBills
extension Member {

    @objc(addMemInBillsObject:)
    @NSManaged public func addToMemInBills(_ value: MemberInBill)

    @objc(removeMemInBillsObject:)
    @NSManaged public func removeFromMemInBills(_ value: MemberInBill)

    @objc(addMemInBills:)
    @NSManaged public func addToMemInBills(_ values: NSSet)

    @objc(removeMemInBills:)
    @NSManaged public func removeFromMemInBills(_ values: NSSet)

}
