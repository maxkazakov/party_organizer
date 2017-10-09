//
//  ContactsPickerViewController.swift
//  PartyOrg
//
//  Created by Максим Казаков on 08/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ContactsUI


class ContactsPickerViewController: UITableViewController {
    
    static let identifier = String(describing: ContactsPickerViewController.self)
    private var granted = false
    private var contacts: [MemberViewData] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AccessDeniedCell.self, forCellReuseIdentifier: AccessDeniedCell.identifier)
        
        title = "SELECT_MEMBERS.CONTACTS".tr()

        let store = CNContactStore()
        store.requestAccess(for: .contacts) { isGranted, error in
            self.granted = isGranted

            if isGranted {
                self.fetchContacts { contacts in
                    for contact in contacts {
                        var contactItem = MemberViewData(name: CNContactFormatter.string(from: contact, style: .fullName)!, phone: contact.phoneNumbers.first?.value.stringValue ?? "")
                        contactItem.avatar = contact.thumbnailImageData.flatMap (UIImage.init)                        
                        self.contacts.append(contactItem)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    
    private func fetchContacts(block: @escaping ([CNContact]) -> Void) {
        DispatchQueue.global().async {
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            var contacts = [CNContact]()
            do {
                try CNContactStore().enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
                DispatchQueue.main.async {
                    block(contacts)
                }
            } catch {
                fatalError("Error while fetching contacts")
            }
        }
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = granted ? .singleLine : .none
        tableView.allowsSelection = granted
        return granted ? contacts.count : 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if granted {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactViewCell.identifier) as! ContactViewCell
            let contact = contacts[indexPath.row]
            cell.setup(name: contact.name, phone: contact.phone, avatar: nil)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccessDeniedCell.identifier)!
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return granted ? 70 : 150
    }
}
