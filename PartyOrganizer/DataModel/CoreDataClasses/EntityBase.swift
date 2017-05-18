//
//  EntityBase.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData

protocol EntityBase{
    init(within context: NSManagedObjectContext)
}

extension EntityBase {
    init(within context: NSManagedObjectContext) {
        print("asdas")
        self = NSEntityDescription.insertNewObject(forEntityName: "\(Self.self)", into: context) as! Self
    }
}
