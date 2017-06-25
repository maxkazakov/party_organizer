//
//  AppComponent.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 26/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import DITranquillity

class AppComponent: DIComponent {
    
    func load(builder: DIContainerBuilder) {
        builder.register(type: UIStoryboard.self)
            .lifetime(.single)
            .initial(name: "Main", bundle: nil)
        
        builder.register(type: DataProvider.init)
            .lifetime(.single)
        
        builder.register(type: EventTablePresenter.init)
            .lifetime(.perScope)
            .injection { $0.dataProvider = $1 }
        
        
        builder.register(vc: EventTableViewController.self)
            .injection { $0.presenter = $1 }
        
        builder.register(type: EventPresenter.init)
            .lifetime(.perScope)
        
        
        builder.register(vc: EventViewController.self)            
            .injection { $0.presenter = $1 }
        
    }
    
}
