//
//  MemberViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 23/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import EVContactsPicker


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
    
    static let identifier = String(describing: MemberViewController.self)
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        
        name.delegate = self
        phone.delegate = self        
        
        self.tableView.separatorStyle = .none

        self.title = "New member".tr()
        if let member = presenter.getMemberViewData(){
            fill(member)
        }
        name.becomeFirstResponder()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_bar"), style: .plain, target: self, action: #selector(dissmiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
    }
    
    
    
    func dissmiss() {
        dismiss(animated: true, completion: nil)
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
        dissmiss()
    }
    
    
    func cancelButtonAction(){
        name.resignFirstResponder()        
        navigationController?.popViewController(animated: true)
    }

    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


