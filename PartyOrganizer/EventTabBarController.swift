//
//  EventTabBarController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class EventTabBarController: UITabBarController, UITabBarControllerDelegate {

    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let billsTab = BillTableViewController()
        billsTab.presenter.event = event
        billsTab.tabBarItem = UITabBarItem(title: "Bills", image: UIImage(named: "BillsTabbarIcon"), tag: 0)
        
        
        let membersTab = MemberTableViewController()
        membersTab.presenter.event = event
        membersTab.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "MembersTabbarIcon"), tag: 0)
        
//        let controllers = [billsTab, membersTab].map({UINavigationController(rootViewController: $0)})
        let controllers = [billsTab, membersTab]
        
        self.setViewControllers(controllers, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
