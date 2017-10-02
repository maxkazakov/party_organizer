//
//  Utils.swift
//  EventOrganizer
//
//  Created by Максим Казаков on 24/09/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}


func measureTime(block: () -> ()) {
    let start = Date()
    block()
    let end = Date()
    let timeInterval: Double = end.timeIntervalSince(start)
    print("Time to evaluate problem \(timeInterval) seconds");    
}
