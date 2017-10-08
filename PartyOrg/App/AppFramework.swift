//
//  AppFramework.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 26/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import DITranquillity

public class AppFramework: DIFramework {
    
    public static func load(container: DIContainer) {
        container.append(part: AppPart.self)
    }
}
