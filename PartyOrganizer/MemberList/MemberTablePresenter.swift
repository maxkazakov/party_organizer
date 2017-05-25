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
    
    func getMember(index: Int) -> Member{
        // TODO переделать это гавно
        guard let mems = event.getMembers() else{
            fatalError()
        }
        
        guard index >= 0 && index < mems.count else{
            fatalError()
        }
        
        return mems[index]
    }
    
    func getMembersCount()  -> Int {
        guard let members = event.members else{
            return 0
        }
        
        return members.count
    }
    
    func getMemberViewData(index: Int) -> MemberViewData{        
        let mem = getMember(index: index)
        return DataConverter.convert(src: mem)
    }
    
    
}
