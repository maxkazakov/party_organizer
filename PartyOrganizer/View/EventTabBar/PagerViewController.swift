//
//  PagerViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 28/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol EventPagerBarActionDelegate: class{
    func exetuceAdd()
    func beginEditing()
    func endEditing()
}

class PagerViewController: ButtonBarPagerTabStripViewController {
    
    var dataProvider: DataProvider!
    var eventInfoView: EventInfoBarTitle!
    
    var beginEditButton: UIBarButtonItem!
    var endEditButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    
    deinit{
        dataProvider.currentEvent = nil
    }
    
//    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int){
//        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex)
//        let currVc = self.viewControllers[currentIndex]
//        (currVc as? EventPagerBarActionDelegate)?.endEditing()
//    }
    
    
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

        addButton =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonAction))
        beginEditButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(beginEditButtonAction))
        
        endEditButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditButtonAction))
        
        self.navigationItem.rightBarButtonItems = [addButton, beginEditButton]
        
        let frame = self.navigationController?.navigationBar.frame
        eventInfoView = EventInfoBarTitle(frame: frame!)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(editEventInfoAction))
        eventInfoView.addGestureRecognizer(tapRecognizer)
        
        self.navigationItem.titleView = eventInfoView
        eventInfoView.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let event = dataProvider.currentEvent, let eventInfo = try?DataConverter.convert(src: event) {
            eventInfoView.setData(title: eventInfo.name, image: eventInfo.image)
        }
        
    }
    
    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIApplication.shared.mainStoryboard
        let billsTab = storyboard!.instantiateViewController(withIdentifier: BillTableViewController.identifier) as! BillTableViewController
        
        let membersTab = storyboard!.instantiateViewController(withIdentifier: MemberTableViewController.identifier) as! MemberTableViewController
        
        return [billsTab, membersTab]
    }
    
    func addButtonAction(){
        let currVc = self.viewControllers[currentIndex]
        (currVc as? EventPagerBarActionDelegate)?.exetuceAdd()
    }
    
    
    func beginEditButtonAction(){
        let currVc = self.viewControllers[currentIndex]
        (currVc as? EventPagerBarActionDelegate)?.beginEditing()
        self.navigationItem.rightBarButtonItems = [addButton, endEditButton]
    }
    
    func endEditButtonAction(){
        let currVc = self.viewControllers[currentIndex]
        (currVc as? EventPagerBarActionDelegate)?.endEditing()
        self.navigationItem.rightBarButtonItems = [addButton, beginEditButton]
    }
    
    func editEventInfoAction(){
        routing(with: .createOrEditEvent)
    }

}

