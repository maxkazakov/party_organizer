//
//  MemberInBill+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData


extension MemberInBill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemberInBill> {
        return NSFetchRequest<MemberInBill>(entityName: "MemberInBill")
    }

    @NSManaged public var sum: Double
    @NSManaged public var bill: Bill?
    @NSManaged public var member: Member?

}
