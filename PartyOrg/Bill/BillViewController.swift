//
//  BillViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 29/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import MMNumberKeyboard
import CoreData

struct BillViewData {
    var name: String
    var cost: Double    
    var memberCount: Int
    
    static let zero = BillViewData(name: "", cost: 0.0, memberCount: 0)
}

struct MemberInBillViewData {
    var name: String
    var debt: Double
    
    init(){
        self.name = ""
        self.debt = 0.0
    }
}


class BillViewController: UITableViewController, MMNumberKeyboardDelegate, UITextFieldDelegate {
    
    static let identifier = String(describing: BillViewController.self)
    
    var presenter: BillPresenter!
    var billData = BillViewData.zero
    
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var billname: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    var addNewMemberBtn = AddNewItemButton(type: .member, accentText: "no_members".tr())
    
    var numericKeyboard: MMNumberKeyboard {
        return MMNumberKeyboard(frame: CGRect.zero)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        
        self.title = "New bill".tr()
        addButton.tintColor = Colors.sectionButton
        sectionLabel.textColor = Colors.sectionButton
        separatorLine.backgroundColor = UIColor(rgb: 0xB35C5B)
        
        self.billData = presenter.getBillViewData()
        fill()
        
        
        if billData.name == "" {
            billname.becomeFirstResponder()
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel_bar"), style: .plain, target: self, action: #selector(dissmiss))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
        numericKeyboard.allowsDecimalPoint = true
        self.presenter.setFetchControllDelegate(delegate: self)
        cost.inputView = numericKeyboard
        cost.delegate = self
        billname.delegate = self
        
        addNewMemberBtn.callback = {
            [unowned self] in
            self.addMembers()
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    func dissmiss() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addMembersAction(_ sender: Any) {
        addMembers()
    }
    
    
    
    @IBAction func editTable(_ sender: Any) {
        if self.tableView.isEditing{
            self.tableView.setEditing(false, animated: true)
        }
        else{
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    
    
    func fill(){
        self.title = billData.name == "" ? "New bill".tr() : billData.name
        billname.text = billData.name
        cost.text = billData.cost.formatCurrency(showZero: false)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    @objc func saveButtonAction(){
        billData.name = billname.text!
        if let costStr = self.cost.text  {
            billData.cost = costStr.toCurrency()
        }
        self.childViewControllers.forEach {
            if let billPhotosVc = $0 as? BillPhotosCollectionViewController {
                billPhotosVc.saveImages()
            }
        }
        presenter.save(billdata: billData)
        dissmiss()
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == cost else {
            return
        }
        if let value = textField.text, value.toCurrency() == 0.0 {
            textField.text = ""
        }
    }
    
    
    
    // MARK: - Private
    
    
    private func addMembers() {
        if !self.presenter.checkMembersExist() {
            self.routing(with: .showAddMembersAlert)
        }
        else {
            self.routing(with: .selectMembers)
        }
    }
    
}



extension BillViewController: AddContactsViewController  {
    func addContacts(contacts: [MemberViewData]) {
        self.presenter.saveMembers(contacts)
    }
}




extension BillViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInBillCell.identifier) as! MemberInBillCell
        let memInBill = presenter.getMemberInBillViewData(indexPath: indexPath)
        
        cell.delegate = self
        cell.setData(memInBill)
        cell.setInputView(view: numericKeyboard)
        return cell
        
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.getMemberInBillCount()
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        return section == 1 ? 0 : count
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MemberInBillCell
        cell.select()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.presenter.delete(indexPath: indexPath)
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 && presenter.getMemberInBillCount() == 0 ? addNewMemberBtn : nil
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 && presenter.getMemberInBillCount() == 0 ? 200 : 0
    }
}

extension BillViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:
            guard let path = newIndexPath else {
                return
            }
            tableView.insertRows(at: [path], with: .automatic)
           
        case .update:
            guard let path = newIndexPath else{
                return
            }
            self.tableView.reloadRows(at: [path], with: .automatic)
            
        case .delete:
            guard let path = indexPath else {
                return
            }
            tableView.deleteRows(at: [path], with: .automatic)
            
        default:
            return
        }
    }
    
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
}

extension BillViewController: MemberInBillCellDelegate {
    
    func debtValueDidChange(sender: MemberInBillCell, value: Double) {
        guard let indexPath = self.tableView.indexPath(for: sender) else {
            return
        }
        
        self.presenter.update(indexPath: indexPath, debt: value)
    }
}

