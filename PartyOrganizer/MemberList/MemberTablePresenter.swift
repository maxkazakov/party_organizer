//
//  MemberTablePresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class MemberTablePrenester {
    var event: Event!
    
    func getMembersCount()  -> Int {
        guard let members = event.members else{
            return 0
        }
        
        return members.count
    }
    
    func getMemberViewData(index: Int) -> MemberViewData{
//        var res = MemberViewData(name: "")

        // TODO переделать это гавно
        guard let mem = event.getMembers() else{
            fatalError()
        }
        
        guard index >= 0 && index < mem.count else{
            fatalError()
        }
        
        return DataConverter.convert(src: mem[index])
    }
    
    
}
