//
//  MemberPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class MemberPresenter{

    var dataProvider: DataProvider!
    
    
    deinit {
        dataProvider.resetMember()
    }
    
    func getMemberViewData() -> MemberViewData?{
        guard let mem = self.dataProvider.currentMember else{
            return nil
        }
               
        return DataConverter.convert(src: mem)
    }
    
    
    func saveEvent(memberData: MemberViewData) {
        
        guard let event = dataProvider.currentEvent else{
            fatalError("Current event is nil")
        }
        
        var mem: Member! = self.dataProvider.currentMember
        if (mem == nil){
            mem = Member(within: CoreDataManager.instance.managedObjectContext)
            mem.dateCreated = Date()
        }
        
        mem.name = memberData.name
        mem.phone = memberData.phone
        event.addToMembers(mem)
        
        CoreDataManager.instance.saveContext()
    }

}
