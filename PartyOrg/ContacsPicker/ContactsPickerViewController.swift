//
//  ContactsPickerViewController.swift
//  PartyOrg
//
//  Created by Максим Казаков on 08/10/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ContactsUI



struct ContactItem {
    var name: String
    var phone: String
    var avatar: UIImage
}


protocol ContactsPickerViewControllerDelegate: class {
    func didSelect(contacts: [ContactItem])
}



class ContactsPickerViewController: UITableViewController {
    
    static let identifier = String(describing: ContactsPickerViewController.self)
    
    var delegate: ContactsPickerViewControllerDelegate?
    
    private var granted = false
    private var contacts = [ContactItem]()
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func done() {
        if let indices = tableView.indexPathsForSelectedRows{
            delegate?.didSelect(contacts: indices.map { contacts[$0.row] })
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = true
        setEditing(true, animated: true)
        tableView.register(AccessDeniedCell.self, forCellReuseIdentifier: AccessDeniedCell.identifier)
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_bar"), style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        title = "SELECT_MEMBERS.CONTACTS".tr()

        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { isGranted, error in
            self.granted = isGranted
            
            if isGranted {
                self.fetchContacts { contacts in
                    for contact in contacts {
                        let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                        let avatar: UIImage = contact.thumbnailImageData.flatMap (UIImage.init) ?? self.getDummyImage(by: name)
                        self.contacts.append(ContactItem(name: name, phone: contact.phoneNumbers.first?.value.stringValue ?? "", avatar: avatar))
                    }
                    
                    self.contacts.sort(by: {a, b in b.name > a.name })
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
            cell.setup(name: contact.name, phone: contact.phone, avatar: contact.avatar)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccessDeniedCell.identifier)!
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return granted ? 76 : 150
    }
    
    
    
    private func getDummyImage(by name: String) -> UIImage {
        let color = getColor()
        let size = CGSize(width: 60, height: 60)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color)
        context.fill(rect)
        let char = name.first ?? "U"
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let charStr = String(repeating: char, count: 1) as NSString
        let textAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 24), NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName : style]
        
        let stringSize = charStr.size(attributes: textAttributes)
        let stringPoint = CGPoint(x: (size.width - stringSize.width) / 2, y: (size.height - stringSize.height) / 2)
        charStr.draw(at: stringPoint, withAttributes: textAttributes)
        
        let cgImage = context.makeImage()!
        UIGraphicsEndImageContext()
        return UIImage(cgImage: cgImage)
    }
    
    private func getColor() -> CGColor {
        let colors = Colors.contactColors
        let index = Int(arc4random()) % colors.count
        return colors[index].cgColor
    }
    
}
