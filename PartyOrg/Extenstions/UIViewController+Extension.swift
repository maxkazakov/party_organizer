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


extension CNContactPickerDelegate where Self: UIViewController, Self: AddContactsViewController {
//    @objc(contactPicker:didSelectContacts:)
//    @objc(contactPicker:didSelectContacts:)
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        var contactsData = [MemberViewData]()
//        for contact in contacts {
//            let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
//            let phone = contact.phoneNumbers.first?.label ?? ""
//            let contactItem = MemberViewData(name: name, phone: phone)
//            contactsData.append(contactItem)
//        }
//        self.addContacts(contacts: contactsData)
//    }
}


