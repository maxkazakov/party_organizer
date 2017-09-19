//
//  Router.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 25/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

//https://habrahabr.ru/post/321842/


import UIKit
import EPContactsPicker

extension UIViewController{
    enum Routing{
        case dismiss
        case createOrEditEvent
        case selectEvent
        case createOrEditMember
        case createOrEditBill
        case selectMembers
        case showAddMembersAlert
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
        case .showAddMembersAlert:
            showAddNewMembersAlert()
        }
    }    
    
}

private extension UIViewController{
    
    func getViewController(byName name: String) -> UIViewController{
        let storyboard = UIApplication.shared.mainStoryboard
        return storyboard!.instantiateViewController(withIdentifier: name)
    }
    
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createOrEditEvent() {
        let eventInfoVc = getViewController(byName: "eventInfoVc")
        self.present(eventInfoVc, animated: true, completion: { _ in })
    }
    
    func selectEvent() {
        let pageVc = getViewController(byName: "pagerVc")
        self.navigationController?.pushViewController(pageVc, animated: true)
    }
    
    func createOrEditMember() {
        let memVc = getViewController(byName: MemberViewController.identifier)
        self.navigationController?.pushViewController(memVc, animated: true)

    }
    
    func createOrEditBill() {
        let billVc = getViewController(byName: BillViewController.identifier)
        self.navigationController?.pushViewController(billVc, animated: true)
    }
    
    func selectMembers() {
        let memSelectVc = getViewController(byName: MemberSelectTableViewController.identifier)
        self.present(memSelectVc, animated: true, completion: nil)
    }
    
    func showAddNewMembersAlert() {
        guard let contactPickerDelegate = self as? EPPickerDelegate else {
            print("Current view controller \(self) is not contact picker delegate.")
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Add single user".tr(), style: .default, handler: { alertAction in
            self.routing(with: .createOrEditMember)
        }))
        alertController.addAction(UIAlertAction(title: "Add users".tr(), style: .default, handler: { alertAction in
            
            let contactPickerScene = EPContactsPicker(delegate: contactPickerDelegate, multiSelection: true, subtitleCellType: .phoneNumber)
            let navigationController = UINavigationController(rootViewController: contactPickerScene)
            self.present(navigationController, animated: true, completion: nil)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel".tr(), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

