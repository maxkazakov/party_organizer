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
    var dataProvider: DataProvider!
    
    private var fetchConroller: NSFetchedResultsController<Member>
    
    func setFetchControllDelegate(delegate: NSFetchedResultsControllerDelegate){
        fetchConroller.delegate = delegate
    }
    
    init(dataProvider: DataProvider){
        self.dataProvider = dataProvider
        self.fetchConroller = CoreDataManager.instance.fetchedResultsController(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)], predicate: NSPredicate(format: "event == %@", argumentArray: [dataProvider.currentEvent!]))
        
        do {
            try fetchConroller.performFetch()
            
        }
        catch {
            print(error)
        }
    }
    
    func getMemberViewData(indexPath: IndexPath) -> MemberViewData{
        let m = fetchConroller.object(at: indexPath)
        return DataConverter.convert(src: m)

    }
    
    func getMember(indexPath: IndexPath) -> Member{
        let member = fetchConroller.object(at: indexPath)
        return member
    }
    
    func getMembersCount()  -> Int {
        if let sections = fetchConroller.sections {
            return sections[0].numberOfObjects
        } else {
            return 0
        }
    }
    
    func delete(indexPath: IndexPath){
        let member = fetchConroller.object(at: indexPath)
        CoreDataManager.instance.managedObjectContext.delete(member)
        CoreDataManager.instance.saveContext()
    }
    
    func selectRow(_ indexPath: IndexPath){
        dataProvider.currentMember = getMember(indexPath: indexPath)
    }
    
    func exclude(members: [Member]){
        
//        self.members = self.members.filter{!members.contains($0)}
    }
    
    
}
