//
//  DataStorage.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 16/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

class DataStorage{
    
    var currentEventId: Int = -1
    
    lazy var events: [Event] = {
        return CoreDataManager.instance.fetchObjects()
    }()    
    
    func getCurrentEvent() -> Event? {
        guard (currentEventId >= 0), (currentEventId < events.count) else{
            return nil
        }
        
        return events[currentEventId]
    }
    
    // Singleton
    static let instance = DataStorage()
    
    private init() {}    
    
}
