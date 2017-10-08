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
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { isGranted, error in
            self.granted = isGranted

            if isGranted {
                // fetch
//                self.tableView.reloadData()
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
