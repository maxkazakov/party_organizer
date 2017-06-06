//
//  File.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 16/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class DataConverter{     
    static func convert(src: Event) throws -> EventViewData {
                
        guard let name = src.name else {
            throw ConvertError.error(text: "Invalid string")
        }
        
        guard let imgData = src.image as Data?, let img = UIImage(data: imgData) else {
            throw ConvertError.error(text: "Invalid image")
        }
        
        
        return EventViewData(name: name, image: img)
    }
    
    static func convert(src: Member) -> MemberViewData {
        var dest = MemberViewData(name: "", phone: "")
        if let name = src.name {
            dest.name = name
        }
        
        if let phone = src.phone {
            dest.phone = phone
        }
       
        return dest
    }
    
    static func convert(src: Bill) -> BillViewData {
        var dest = BillViewData()
        if let name = src.name {
            dest.name = name
        }
        
        dest.cost = src.cost

        if let imgs = src.images{
            let images = imgs.map( {
                UIImage(data: ($0.image as Data?)!)
            } ).filter({$0 == nil})
            
            dest.images = images.map({$0!})
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
