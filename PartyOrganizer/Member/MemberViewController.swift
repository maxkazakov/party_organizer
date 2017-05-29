//
//  MemberViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import ContactsUI

class MemberViewController: UITableViewController, CNContactPickerDelegate {

    var presenter = MemberPresenter()    
//    var member: MemberViewData!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "New member"
        if let member = presenter.getMemberViewData(){
            fill(member)
        }
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
    }

    func fill(_ member: MemberViewData){
        name.text = member.name
        self.title = name.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            tableView.backgroundView = emptyTableView
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        default:
            return 0
        }
        // #warning Incomplete implementation, return the number of rows
//        let cnt = presenter.getMembersCount()
//        if cnt > 0{
//            tableView.backgroundView = nil
//            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//            tableHeader.layer.isHidden = false
//        }
//        else{
            //        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Bills"
        default:
            return nil
        }
    }

    func saveButtonAction(){
        name.resignFirstResponder()
        
        presenter.saveEvent(name: name.text!)
        navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonAction(){
        name.resignFirstResponder()        
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func addFromInfo(_ sender: Any) {
        print("qwe")
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        var view = EmptyTableMessageView("Bill", showAddAction: false)
        return view
    }()
    
    @IBAction func addMember(_ sender: Any) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // MARK: CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        self.name.text = CNContactFormatter.string(from: contact, style: .fullName)!
        self.phone.text = (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
    }
    
}
