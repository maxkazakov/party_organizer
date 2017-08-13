//
//  MembersFromContactsSelection.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 13/08/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation


class MembersFromContactsSelection {
    extension PagerViewController: CNContactPickerDelegate {
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            var contactsInfo = [(name: String, phone: String)]()
            for contact in contacts {
                contactsInfo.append((name: CNContactFormatter.string(from: contact, style: .fullName)!, phone: contact.phoneNumbers.first?.value.stringValue))
            }
        }
    }
    
}
