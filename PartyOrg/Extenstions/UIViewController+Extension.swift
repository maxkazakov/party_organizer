//
//  UIViewController+Extension.swift
//  PartyOrg
//
//  Created by Максим Казаков on 04/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ContactsUI



protocol AddContactsViewController {
    func addContacts(contacts: [MemberViewData])    
}


extension ContactsPickerViewControllerDelegate where Self: UIViewController, Self: AddContactsViewController {
    func didSelect(contacts: [ContactItem]) {
        var contactsData = [MemberViewData]()
        for contact in contacts {
            let contactItem = MemberViewData(name: contact.name, phone: contact.phone)
            contactsData.append(contactItem)
        }
        self.addContacts(contacts: contactsData)
    }
}


