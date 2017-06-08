//
//  BillPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 30/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class BillPresenter{
    
    var event: Event?
    var bill: Bill?
    var members = [Member]()
    
    // участники, которых при сохранении нужно удалить
    var toRemoveMembers = [MemberInBill]()
    
    func getBillViewData() -> BillViewData? {
        guard let bill = self.bill else{
            return nil
        }
        
        return DataConverter.convert(src: bill)
    }
    
    func getMembersinBillViewData() -> [MemberInBillViewData]{
        guard let membersInBill = bill?.memInBills else{
            return []
        }
        return membersInBill.map({
            self.members.append($0.member!)
            return DataConverter.convert(src: $0)
        })
    }
    
    
    func addMember(member: Member){
        members.append(member)
    }
    
    func removeMemberInBill(idx: Int){
        let member = self.members[idx]
        
        if let membersInBill = bill!.memInBills,
            let memInBill = membersInBill.first(where: {$0.member == member}){
            toRemoveMembers.append(memInBill)
        }
        
        self.members.remove(at: idx)
    }
    
    func save(billdata: BillViewData, membersdata: [MemberInBillViewData]){
        // удаляем 
        for memInBill in self.toRemoveMembers{
            CoreDataManager.instance.delete(obj: memInBill)
        }
        
        
        if (self.bill == nil){
            self.bill = Bill(within: CoreDataManager.instance.managedObjectContext)
            self.bill?.dateCreated = Date()
        }
        
        guard let b = self.bill else{
            return
        }
        
        if membersdata.count != self.members.count{
            fatalError()
        }
        
        let membersInBill = bill!.memInBills

        for (idx, memData) in membersdata.enumerated(){
            
            let mem = self.members[idx]
            
            // проверяем на наличие
            if let memInBill = membersInBill?.first(where: {$0.member == mem}){
                memInBill.sum = memData.debt
            }
            else{
                let memInBill = MemberInBill(within: CoreDataManager.instance.managedObjectContext)
                memInBill.sum = memData.debt
                memInBill.member = mem
                memInBill.bill = self.bill
            }
        }
        
        b.name = billdata.name
        b.cost = billdata.cost
        self.event?.addToBills(b)
        
        CoreDataManager.instance.saveContext()
    }
    
}
