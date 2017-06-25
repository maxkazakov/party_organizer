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
        case newEvent
        case selectEvent(IndexPath)
    }
    
    
    func routing(with routing: Routing){
        switch routing{
            
        case .dismiss:
            dismiss()
        case .newEvent:
            newEvent()
        case .selectEvent(let indexPath):
            selectEvent(with: indexPath)
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
    
    func newEvent(){
        let eventInfoVc = getViewController(byName: "eventInfoVc")
        self.present(eventInfoVc, animated: true, completion: { _ in })
    }
    
    func selectEvent(with indexPath: IndexPath){
        let pageVc = getViewController(byName: "pagerVc")
        self.navigationController?.pushViewController(pageVc, animated: true)
    }
    
    
    
}

//extension UIViewController{
//    
//    enum ViewType{
//        case undefined
//    }
//    
//    private struct Keys {
//        static var key = "\(#file)+\(#line)"
//    }
//    
//    var type: ViewType {
//        get {
//            return objc_getAssociatedObject(self, &Keys.key) as? ViewType ?? .undefined
//        }
//        set {
//            objc_setAssociatedObject(self, &Keys.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//}


