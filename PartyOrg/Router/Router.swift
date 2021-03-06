//
//  Router.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 25/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

//https://habrahabr.ru/post/321842/


import UIKit
import ContactsUI

extension UIViewController{
    enum Routing{
        case dismiss
        case createOrEditEvent
        case selectEvent
        case createOrEditMember
        case createOrEditBill
        case selectMembers
        case showAddMembersAlert(sender: Any)
    }
    
    
    func routing(with routing: Routing){
        switch routing{
            
        case .dismiss:
            dismiss()
        case .createOrEditEvent:
            createOrEditEvent()
        case .selectEvent:
            selectEvent()
        case .createOrEditMember:
            createOrEditMember()
        case .createOrEditBill:
            createOrEditBill()
        case .selectMembers:
            selectMembers()
        case .showAddMembersAlert(let view):
            showAddNewMembersAlert(sender: view)
        }
    }    
    
}

private extension UIViewController {
    
    func getViewController(byName name: String) -> UIViewController{
        let storyboard = UIApplication.shared.mainStoryboard
        return storyboard!.instantiateViewController(withIdentifier: name)
    }
    
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createOrEditEvent() {
        let eventInfoVc = getViewController(byName: "eventInfoVc")
        self.present(eventInfoVc, animated: true, completion: nil)
    }
    
    func selectEvent() {
        let pageVc = getViewController(byName: "pagerVc")
        self.navigationController?.pushViewController(pageVc, animated: true)
    }
    
    func createOrEditMember() {
        let memVc = getViewController(byName: MemberViewController.identifier)
        self.present(memVc, animated: true, completion: nil)
    }
    
    func createOrEditBill() {
        let billVc = getViewController(byName: BillViewController.identifier)
        self.present(billVc, animated: true, completion: nil)
    }
    
    func selectMembers() {
        let memSelectVc = getViewController(byName: MemberSelectTableViewController.identifier)
        self.present(memSelectVc, animated: true, completion: nil)
    }
    
    func showAddNewMembersAlert(sender: Any) {
        guard let contactPickerDelegate = self as? ContactsPickerViewControllerDelegate else {
            fatalError("Current view controller \(self) is not contact picker delegate.")
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let senderBarButton = sender as? UIBarButtonItem {
            alertController.popoverPresentationController?.barButtonItem = senderBarButton
        }
        else {
            let senderView = self.view!
            alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            alertController.popoverPresentationController?.sourceView = senderView
            let rect = CGRect(x: senderView.bounds.midX, y: senderView.bounds.midY, width: 0, height: 0)
            print(rect)
            alertController.popoverPresentationController?.sourceRect = rect
        }
        
        
        alertController.addAction(UIAlertAction(title: "Add single user".tr(), style: .default, handler: { alertAction in
            self.routing(with: .createOrEditMember)
        }))
        alertController.addAction(UIAlertAction(title: "Add users".tr(), style: .default, handler: { alertAction in
            let contactPickerNavVC = self.getViewController(byName: ContactsPickerViewController.identifier) as! UINavigationController
            let contactPickerVC = contactPickerNavVC.viewControllers.first as! ContactsPickerViewController             
            contactPickerVC.delegate = contactPickerDelegate
            self.present(contactPickerNavVC, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".tr(), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}


