//
//  AppComponent.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 26/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import DITranquillity


class AppPart: DIPart {
    static func load(container: DIContainer) {
        container.registerStoryboard(name: "Main", bundle: Bundle.main)
        
        container.register(DataCacheStorage.init)
            .lifetime(.single)
        
        
        container.register(UINavigationController.self)
            .lifetime(.prototype)
        
        
        container.register(EventTablePresenter.init)
            .lifetime(.prototype)
            .injection { $0.dataProvider = $1 }
        
        
        container.register(EventTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        container.register(EventPresenter.init)
            .lifetime(.prototype)
            .injection { $0.dataProvider = $1 }
        
        container.register(EventViewController.self)
            .injection { $0.presenter = $1 }
        
        container.register(PagerViewController.self)
            .injection { $0.dataProvider = $1 }
            .lifetime(.prototype)
        
        //
        
        container.register(BillTablePrenester.init)
            .lifetime(.prototype)
       
        
        container.register(BillTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        
        container.register(MemberTablePrenester.init)            
            .lifetime(.prototype)
        
        
        container.register(MemberTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        //
        
        container.register(MemberPresenter.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.prototype)
        
        
        container.register(MemberViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        container.register(BillPresenter.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.prototype)
        
        container.register(BillViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        container.register(MemberSelectPrenester.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.prototype)
        
        container.register(MemberSelectTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        container.register(BillPhotosCollectionViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.prototype)
        
        container.register(BillPhotosPresenter.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.prototype)
    }
    
}
