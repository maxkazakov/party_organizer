//
//  PagerViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 28/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol EventTabbarAddAction{
     func exetuce()
}

class PagerViewController: ButtonBarPagerTabStripViewController {
    
    var event: Event!
    var eventInfoView: EventInfoBarTitle!
    
    override func viewDidLoad() {
        // set up style before super view did load is executed
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor.purple
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        //-
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = UIColor.purple
        }
        
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        
        let frame = self.navigationController?.navigationBar.frame
        eventInfoView = EventInfoBarTitle(frame: frame!)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEventInfoAction))
        eventInfoView.addGestureRecognizer(tapRecognizer)
        
        self.navigationItem.titleView = eventInfoView
        eventInfoView.layout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventInfoView.setData(title: event.name!, image: event.getImage())
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIApplication.shared.mainStoryboard
        let billsTab = storyboard!.instantiateViewController(withIdentifier: BillTableViewController.identifier) as! BillTableViewController
        billsTab.presenter.event = event
        billsTab.tabBarItem = UITabBarItem(title: "Bills", image: UIImage(named: "BillsTabbarIcon"), tag: 0)
        
        let membersTab = storyboard!.instantiateViewController(withIdentifier: MemberTableViewController.identifier) as! MemberTableViewController
        membersTab.presenter.event = event
        membersTab.tabBarItem = UITabBarItem(title: "Members", image: UIImage(named: "MembersTabbarIcon"), tag: 0)
        
        return [billsTab, membersTab]
    }
    
    func addButtonAction(){
        let currVc = self.viewControllers[currentIndex]
        (currVc as? EventTabbarAddAction)?.exetuce()
    }
    
    func editEventInfoAction(){
        let storyboard = UIApplication.shared.mainStoryboard
        let eventInfoNav = storyboard!.instantiateViewController(withIdentifier: "eventInfoVc") as! UINavigationController
        let eventVc = eventInfoNav.topViewController as! EventViewController
        
        eventVc.presenter.event = self.event
        self.present(eventInfoNav, animated: true, completion: { _ in })
    }

}

