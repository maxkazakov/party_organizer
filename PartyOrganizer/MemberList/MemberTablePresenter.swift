//
//  MemberTablePresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import CoreData

class MemberTablePrenester {

    var dataProvider: DataCacheStorage!
    
    private var fetchController: NSFetchedResultsController<Member>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchController.delegate = delegate
    }
    
    init(dataProvider: DataCacheStorage){
        self.dataProvider = dataProvider
        self.fetchController = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: NSPredicate(format: "event == %@", argumentArray: [dataProvider.currentEvent!]))
        
        do {
            try fetchController.performFetch()
            
        }
        catch {
            print(error)
        }
    }
    
    func getMemberViewData(indexPath: IndexPath) -> MemberViewData{
        let m = fetchController.object(at: indexPath)
        return DataConverter.convert(src: m)
        
    }
    
    func getMember(indexPath: IndexPath) -> Member{
        let member = fetchController.object(at: indexPath)
        return member
    }
    
    func getMembersCount()  -> Int {
        if let sections = fetchController.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func delete(indexPath: IndexPath){
        CoreDataManager.instance.saveContext{
            [unowned self] in
            let member = self.fetchController.object(at: indexPath)
            CoreDataManager.instance.managedObjectContext.delete(member)
        }
    }
    
    func selectRow(_ indexPath: IndexPath){
        dataProvider.currentMember = getMember(indexPath: indexPath)
    }
    
    func saveMembers(_ contacts: [MemberViewData]){
        for contact in contacts {
            CoreDataManager.instance.saveContext{
                [unowned self] in
                guard let event = self.dataProvider.currentEvent else{
                    fatalError("Current event is nil")
                }
                
                var mem: Member! = self.dataProvider.currentMember
                if (mem == nil){
                    mem = Member(within: CoreDataManager.instance.managedObjectContext)
                    mem.dateCreated = Date()
                }
                
                mem.name = contact.name
                mem.phone = contact.phone
                event.addToMembers(mem)                
            }
        }
    }

    
}
