//
//  File.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 16/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class DataConverter {
    
    static func convert(src: Event) -> EventViewData {
        var eventViewData = EventViewData.zero
        eventViewData.name = src.name ?? ""
        if let imgData = src.image as Data?, let img = UIImage(data: imgData) {
            eventViewData.image = img
        }
        eventViewData.budget = src.bills?.reduce(0.0, { $1.cost }) ?? 0.0
        return eventViewData
    }
    
    
    
    static func convert(src: Member) -> MemberViewData {
        var dest = MemberViewData(name: "", phone: "")
        if let name = src.name {
            dest.name = name
        }
        if let phone = src.phone {
            dest.phone = phone
        }
        
        var sum: Double = 0.0
        if let bills = src.memInBills{
            for memInBill in bills{
                sum += memInBill.sum                
            }
        }
        
        dest.sumDebt = sum
              
        return dest
    }
    
    static func convert(src: Bill) -> BillViewData {
        var dest = BillViewData.zero
        
        if let name = src.name {
            dest.name = name
        }
        
        dest.cost = src.cost
        
        if let mems = src.memInBills{
            dest.memberCount = mems.count
        }

        if let imgs = src.images{
            let images = imgs.map( {
                UIImage(data: ($0.image as Data?)!)
            } ).filter({$0 == nil})
            
            dest.images = images.flatMap({$0})
        }
       
        return dest
    }
    
    static func convert(src: MemberInBill) -> MemberInBillViewData {
        var dest = MemberInBillViewData()
        if let mem = src.member, let name = mem.name {
            dest.name = name            
        }
        
        dest.debt = src.sum
        
        return dest
    }
}