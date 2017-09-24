//
//  ManagedContextExtension.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 04/07/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext{
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print("error save. \(error)")
            rollback()
            return false
        }
    }
    
    func performAndSaveChanges(block: @escaping (NSManagedObjectContext) -> ()) {
        perform {
            block(self)
            _ = self.saveOrRollback()
        }
    }
}
