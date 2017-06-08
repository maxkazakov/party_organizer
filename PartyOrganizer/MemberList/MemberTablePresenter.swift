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
    
    lazy var members: [Member] = {
        guard let mems = self.event.members else{
            return []
        }
        return mems
    }()
    
    
    func getMember(index: Int) -> Member{
        
        guard index >= 0 && index < members.count else{
            fatalError()
        }
        
        return members[index]
    }
    
    func getMembersCount() -> Int {
        return members.count
    }
    
    func getMemberViewData(index: Int) -> MemberViewData{        
        let mem = getMember(index: index)
        return DataConverter.convert(src: mem)
    }
    
    func exclude(members: [Member]){
        self.members = self.members.filter{!members.contains($0)}
    }
    
    
}
