//
//  UIViewController+Extension.swift
//  PartyOrg
//
//  Created by Максим Казаков on 04/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import EVContactsPicker

protocol AddContactsViewController {
    func addContacts(contacts: [MemberViewData])    
}


extension EVContactsPickerDelegate where Self: UIViewController, Self: AddContactsViewController {
    func didChooseContacts(_ contacts: [EVContactProtocol]?) {
        guard let contacts = contacts else {
            return
        }
        
        var contactsInfo = [MemberViewData]()
        for contact in contacts {
            contactsInfo.append(MemberViewData(name: contact.fullname() ?? "", phone: contact.phone ?? ""))
        }
        self.addContacts(contacts: contactsInfo)
        self.navigationController?.popViewController(animated: true)
    }
}

