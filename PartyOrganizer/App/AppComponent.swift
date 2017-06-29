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
            .lifetime(.perDependency)
        
        builder.register(type: EventPresenter.init)
            .lifetime(.perDependency)
            .injection { $0.dataProvider = $1 }
        
        builder.register(vc: EventViewController.self)
            .injection { $0.presenter = $1 }
        
        builder.register(vc: PagerViewController.self)
            .injection { $0.dataProvider = $1 }
            .lifetime(.perDependency)
        
        //
        
        builder.register(type: BillTablePrenester.self)
            .initial{ BillTablePrenester(dataProvider: $0) }
            .lifetime(.perDependency)
       
        
        builder.register(vc: BillTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.perDependency)
        
        
        builder.register(type: MemberTablePrenester.init)
            .initial{ MemberTablePrenester(dataProvider: $0) }
            .lifetime(.perDependency)
        
        
        builder.register(vc: MemberTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.perDependency)
        
        //
        
        builder.register(type: MemberPresenter.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.perDependency)
        
        builder.register(vc: MemberViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.perDependency)
        
        builder.register(type: BillPresenter.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.perDependency)
        
        builder.register(vc: BillViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.perDependency)
        
        builder.register(type: MemberSelectPrenester.init)
            .injection { $0.dataProvider = $1 }
            .lifetime(.perDependency)
        
        builder.register(vc: MemberSelectTableViewController.self)
            .injection { $0.presenter = $1 }
            .lifetime(.perDependency)
    }
    
}
