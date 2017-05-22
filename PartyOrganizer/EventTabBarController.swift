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
    var eventInfoView: EventInfoBarTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        let frame = self.navigationController?.navigationBar.frame
        eventInfoView = EventInfoBarTitle(frame: frame!)
        eventInfoView.layout()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEventInfoAction))
        eventInfoView.addGestureRecognizer(tapRecognizer)
        

//        eventInfoView.layer.borderWidth = 2.0
        self.navigationItem.titleView = eventInfoView
        
        let billsTab = BillTableViewController()
        billsTab.presenter.event = event
        billsTab.tabBarItem = UITabBarItem(title: "Bills", image: UIImage(named: "BillsTabbarIcon"), tag: 0)
        
        
        let membersTab = MemberTableViewController()
        membersTab.presenter.event = event
        membersTab.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "MembersTabbarIcon"), tag: 0)
        
        let controllers = [billsTab, membersTab]
        
        self.setViewControllers(controllers, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventInfoView.setData(title: event.name!, image: event.getImage())        
    }
    
    // MARK: Nav bar actions
    
    func addButtonAction(){
        print("qwe")
    }
    
    func editEventInfoAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventInfoNav = storyboard.instantiateViewController(withIdentifier: "eventInfoVc") as! UINavigationController
        let eventVc = eventInfoNav.topViewController as! EventViewController
        
        eventVc.presenter.event = self.event
        self.present(eventInfoNav, animated: true, completion: { _ in })
    }
    
}
