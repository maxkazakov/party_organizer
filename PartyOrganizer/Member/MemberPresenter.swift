//
//  MemberPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class MemberPresenter{
 
    var event: Event?
    var member: Member?
    var memberInBills: [MemberInBill]?
    
    func getMemberViewData() -> MemberViewData?{
        guard let mem = self.member else{
            return nil
        }
        
        return DataConverter.convert(src: mem)
    }
    
    func saveEvent(name: String) {
        if (self.member == nil){
            self.member = Member(within: CoreDataManager.instance.managedObjectContext)
//            self.member?.event = self.event
//            self.member?.dateCreated = Date()
        }
        
        guard let m = self.member else{
            return
        }
        m.name = name
        self.event?.addToMembers(m)
        
        CoreDataManager.instance.saveContext()
    }

}
