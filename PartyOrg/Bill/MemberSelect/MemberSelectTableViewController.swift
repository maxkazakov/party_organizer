//
//  MemberSelectTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 29/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData
import ContactsUI


class MemberSelectTableViewController: UITableViewController, CNContactPickerDelegate {
    static let identifier = String(describing: MemberSelectTableViewController.self)
    
    var presenter: MemberSelectPrenester!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.setFetchControllDelegate(delegate: self)
        
        self.title = "Select members".tr()
        self.tableView.allowsMultipleSelectionDuringEditing = true        
        self.setEditing(true, animated: true)
    }

    
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt =  presenter.getMembersCount()
        
        if cnt > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        else{
            addNewMemberBtn.callback = {
                [unowned self] in
                self.routing(with: .showAddMembersAlert)
            }
            tableView.backgroundView = addNewMemberBtn
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member = presenter.getMemberViewData(indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberCheckableViewCell.identifier, for: indexPath)
            as! MemberCheckableViewCell
        cell.name.text = member.name
        return cell
    }

    
    //MARK: -Outlets

    @IBAction func doneAction(_ sender: Any) {
        if let indices = tableView.indexPathsForSelectedRows{
            self.presenter.select(indices)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addNewMemberAction(_ sender: Any) {
        routing(with: .showAddMembersAlert)
    }
    
    
    //MARK: -Private
    
    private let addNewMemberBtn = AddNewItemButton(type: .member, accentText: "no_members".tr())

}



extension MemberSelectTableViewController: AddContactsViewController {
    func addContacts(contacts: [MemberViewData]) {
        self.presenter.saveMembers(contacts)
    }
}



extension MemberSelectTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let path = newIndexPath else{
                return
            }
            tableView.insertRows(at: [path], with: .automatic)
            
        case .update:
            guard let path = newIndexPath else{
                return
            }
            self.tableView.reloadRows(at: [path], with: .automatic)
            
        case .delete:
            guard let path = indexPath else{
                return
            }
            tableView.deleteRows(at: [path], with: .automatic)
            
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
