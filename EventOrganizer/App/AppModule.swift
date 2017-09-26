//
//  AppModule.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 26/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import DITranquillity

public class AppModule: DIModule {
    public var components: [DIComponent] { return [AppComponent()
        ]}
    
    public var dependencies = [DIModule]()
}
