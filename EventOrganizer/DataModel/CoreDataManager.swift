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
    
    func saveContext (block: @escaping () -> ()) {
        self.managedObjectContext.performChanges(block: block)
    }
    
    func delete(obj: NSManagedObject){
        self.managedObjectContext.delete(obj)        
    }
    
    
    
    func countForFetch<EntityType: NSFetchRequestResult>(predicate: NSPredicate?, entityType: EntityType.Type) -> Int {
        let fetchRequest = NSFetchRequest<EntityType>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate
        
        return (try? self.managedObjectContext.count(for: fetchRequest)) ?? 0
    }
    
    func fetchObjects<EntityType: NSFetchRequestResult>(predicate: NSPredicate?) -> [EntityType]{
        let fetchRequest = NSFetchRequest<EntityType>(entityName: String(describing: EntityType.self))
        fetchRequest.predicate = predicate
        do {            
            return try self.managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print(error)
            return [EntityType]()
        }
    }
    
    // Fetched Results Controller for Entity Name
    func fetchedResultsController<EntityType: NSFetchRequestResult>(sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate? = nil) -> NSFetchedResultsController<EntityType> {
        
        let fetchRequest = NSFetchRequest<EntityType>(entityName: String(describing: EntityType.self))
        
        
        fetchRequest.sortDescriptors = sortDescriptors
        
        fetchRequest.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    
    // Entity for Name
    func entityForName(_ entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!        
    }
}
