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
    var identifier: String
    var name: String
    var phone: String
    var avatar: UIImage
}


protocol ContactsPickerViewControllerDelegate: class {
    func didSelect(contacts: [ContactItem])
}



class ContactsPickerViewController: UITableViewController {
    
    static let identifier = String(describing: ContactsPickerViewController.self)
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchController = UISearchController(searchResultsController: nil)
    var delegate: ContactsPickerViewControllerDelegate?
    // private var granted: Bool! - WTF?! Segmentation fault
    private var granted: Bool?
    private var contacts = [ContactItem]()
    private var filteredContacts = [ContactItem]()
    private var selectedItems = Dictionary<String, ContactItem>()
    
    
    
    func cancel() {
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func done() {
        delegate?.didSelect(contacts: Array(selectedItems.values))
        
        if searchController.isActive {
            searchController.dismiss(animated: false, completion: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        setEditing(true, animated: true)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(AccessDeniedCell.self, forCellReuseIdentifier: AccessDeniedCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LoadingCell")
        
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_bar"), style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done".tr(), style: .done, target: self, action: #selector(done))
        title = "SELECT_MEMBERS.CONTACTS".tr()

        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { isGranted, error in
            if isGranted {
                self.fetchContacts { contacts in
                    for contact in contacts {
                        var phone = contact.phoneNumbers.first?.value.stringValue ?? ""
                        var name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                        if name.isEmpty {
                            if phone.isEmpty {
                                continue
                            }
                            name = phone
                            phone = ""                            
                        }
                        let avatar: UIImage = contact.thumbnailImageData.flatMap (UIImage.init) ?? self.getDummyImage(by: name)
                        self.contacts.append(ContactItem(identifier: contact.identifier, name: name, phone: phone, avatar: avatar))
                    }
                    self.contacts.sort(by: {a, b in b.name > a.name })
                    self.granted = isGranted
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    
    
    
    private func fetchContacts(block: @escaping ([CNContact]) -> Void) {
        DispatchQueue.global().async {
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactIdentifierKey as CNKeyDescriptor]
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
        guard let granted = granted else {
            tableView.separatorStyle = .none
            activityIndicator.center = view.center
            activityIndicator.frame.origin = CGPoint(x: activityIndicator.frame.origin.x, y: 75)
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            return 0
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        tableView.separatorStyle = granted ? .singleLine : .none
        tableView.allowsSelection = granted
        if granted {
            return isFiltering() ? filteredContacts.count : contacts.count
        }
        return 1
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if granted! {
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactViewCell.identifier) as! ContactViewCell
            let contact = isFiltering() ? filteredContacts[indexPath.row] : contacts[indexPath.row]
            cell.setup(name: contact.name, phone: contact.phone, avatar: contact.avatar)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AccessDeniedCell.identifier)!
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return granted! ? 76 : 150
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contacts = isFiltering() ? filteredContacts : self.contacts
        let contact = contacts[indexPath.row]
        selectedItems[contact.identifier] = contact
    }
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let contacts = isFiltering() ? filteredContacts : self.contacts
        selectedItems.removeValue(forKey: contacts[indexPath.row].identifier)
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
    
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    func filterContent(for searchText: String) {
        let lowcasedSearchString = searchText.lowercased()
        filteredContacts = contacts.filter { contact in
            return contact.name.lowercased().contains(lowcasedSearchString) || contact.phone.lowercased().contains(lowcasedSearchString)
        }
        
        filteredContacts = filteredContacts.sorted { left, right in
            let leftLowcasedName = left.name.lowercased()
            let rightLowcasedName = right.name.lowercased()
            
            if leftLowcasedName.hasPrefix(lowcasedSearchString) && !(rightLowcasedName.hasPrefix(lowcasedSearchString)) {
                return true
            }
            return leftLowcasedName < rightLowcasedName
        }
        
        tableView.reloadData()
    }
    
    
    func selectCells() {
        let contacts = isFiltering() ? filteredContacts : self.contacts
        for (idx, contact) in contacts.enumerated() {
            if selectedItems.contains (where: { $0.key == contact.identifier }) {
                tableView.selectRow(at: IndexPath(indexes: [0, idx]) , animated: false, scrollPosition: .none)
            }
        }
    }
}


extension ContactsPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
        selectCells()
    }
}












