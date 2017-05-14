//
//  CoreDataManager.swift
//  CoreDataSample
//
//  Created by Максим Казаков on 07/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
    // Singleton
    static let instance = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PartyOrganizer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects<EntityType: NSFetchRequestResult>() -> [EntityType]{
        let fetchRequest = NSFetchRequest<EntityType>(entityName: String(describing: EntityType.self))
        do {            
            return try self.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print(error)
            return [EntityType]()
        }
    }
    
    
    // Entity for Name
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!        
    }
}
