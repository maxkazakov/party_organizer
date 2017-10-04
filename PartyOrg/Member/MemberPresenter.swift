//
//  MemberPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class MemberPresenter{

    var dataProvider: DataCacheStorage!
    
    
    deinit {
        dataProvider.resetMember()
    }
    
    func getMemberViewData() -> MemberViewData?{
        guard let mem = self.dataProvider.currentMember else{
            return nil
        }
               
        return DataConverter.convert(src: mem)
    }
    
    
    func saveMember(memberData: MemberViewData) {
        CoreDataManager.instance.saveContext { [unowned self] context in
            guard let event = self.dataProvider.currentEvent else{
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
            
        }
    }

}
