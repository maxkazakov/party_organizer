//
//  Router.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 25/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

//https://habrahabr.ru/post/321842/


import UIKit

extension UIViewController{
    enum Routing{
        case dismiss
        case createOrEditEvent
        case selectEvent
        case createOrEditMember
        case createOrEditBill
        case selectMembers
        
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
        default:
            break
        }
    }    
    
}

private extension UIViewController{
    
    func getViewController(byName name: String) -> UIViewController{
        let storyboard = UIApplication.shared.mainStoryboard
        return storyboard!.instantiateViewController(withIdentifier: name)
    }
    
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func createOrEditEvent(){
        let eventInfoVc = getViewController(byName: "eventInfoVc")
        self.present(eventInfoVc, animated: true, completion: { _ in })
    }
    
    func selectEvent(){
        let pageVc = getViewController(byName: "pagerVc")
        self.navigationController?.pushViewController(pageVc, animated: true)
    }
    
    func createOrEditMember(){
        let memVc = getViewController(byName: MemberViewController.identifier)
        self.navigationController?.pushViewController(memVc, animated: true)

    }
    
    func createOrEditBill(){
        let billVc = getViewController(byName: BillViewController.identifier)
        self.navigationController?.pushViewController(billVc, animated: true)
    }
    
    func selectMembers(){
        let memSelectVc = getViewController(byName: MemberSelectTableViewController.identifier)
        self.present(memSelectVc, animated: true, completion: nil)
    }
    
    
}

