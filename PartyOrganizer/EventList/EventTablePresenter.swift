//
//  EventListPresenter.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 14/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation
import UIKit

enum ConvertError: Error{
    case error (text: String)
}

class EventTablePresenter{
    
    weak var view: EventTableViewController!
    
    init(view: EventTableViewController){
        self.view = view
    }
    
    func getEvents(success: (EventViewData) -> (Void)){
        let events: [Event] = CoreDataManager.instance.fetchObjects()
        
        for e in events{
            do {
                let event = try convert(src: e)
                success(event)
            }
            catch ConvertError.error(let text){
                print(text)
            }
            catch{
                print("Unknown error")
            }
        }
        
    }
    
    func convert(src: Event) throws -> EventViewData {
        guard let name = src.name else {
            throw ConvertError.error(text: "Invalid string")
        }
        
        guard let imgData = src.image as Data?, let img = UIImage(data: imgData) else {
            throw ConvertError.error(text: "Invalid image")
        }


        return EventViewData(name: name, image: img)
    }
    
}
