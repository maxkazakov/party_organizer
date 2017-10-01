//
//  MemberViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import EPContactsPicker


struct MemberViewData{
    var name: String
    var phone: String
    var sumDebt: Double = 0.0
    
    init(name: String, phone: String){
        self.name = name
        self.phone = phone
    }
}

class MemberViewController: UITableViewController, UITextFieldDelegate {

    var presenter: MemberPresenter!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var addInfoButton: UIButton!
    
    static let identifier = String(describing: MemberViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        
        name.delegate = self
        phone.delegate = self
        addInfoButton.tintColor = Colors.sectionButton
        
        self.tableView.separatorStyle = .none

        self.title = "New member".tr()
        if let member = presenter.getMemberViewData(){
            fill(member)
        }
        name.becomeFirstResponder()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
    }

    func fill(_ member: MemberViewData){
        name.text = member.name
        phone.text = member.phone
        self.title = name.text
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
   

    @objc func saveButtonAction(){
        name.resignFirstResponder()
        
        let memberData = MemberViewData(name: name.text!, phone: phone.text!)
        presenter.saveMember(memberData: memberData)
        navigationController?.popViewController(animated: true)
    }
    
    
    func cancelButtonAction(){
        name.resignFirstResponder()        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addMember(_ sender: Any) {
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection: false, subtitleCellType: .phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension MemberViewController: EPPickerDelegate {
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) {
        self.name.text = "\(contact.firstName) \(contact.lastName)"
        self.phone.text = contact.phoneNumbers.first?.phoneNumber ?? ""
    }
    
}

