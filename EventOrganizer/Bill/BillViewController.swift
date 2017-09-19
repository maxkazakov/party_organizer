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
    var images: [UIImage]
    var memberCount: Int
    
    static let zero = BillViewData(name: "", cost: 0.0, images: [], memberCount: 0)
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
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sectionTf: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    var addNewMemberBtn = AddNewItemButton(type: .member, accentText: "no_bills".tr())
    
    var numericKeyboard: MMNumberKeyboard {
        return MMNumberKeyboard(frame: CGRect.zero)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        
        self.title = "New bill".tr()
        editButton.tintColor = Colors.sectionButton
        addButton.tintColor = Colors.sectionButton
        sectionTf.textColor = Colors.sectionText
        separatorLine.backgroundColor = UIColor(rgb: 0xB35C5B)
        
        self.billData = presenter.getBillViewData()
        fill()
    
        
        if billData.name == "" {
            name.becomeFirstResponder()
        }
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
        numericKeyboard.allowsDecimalPoint = true
        self.presenter.setFetchControllDelegate(delegate: self)
        cost.inputView = numericKeyboard
        cost.delegate = self
        
        addNewMemberBtn.callback = {
            [unowned self] in
            self.routing(with: .selectMembers)
        }
    }
    
    
    
    @IBAction func addMember(_ sender: Any) {
        self.routing(with: .selectMembers)
    }
    
    
    
    @IBAction func editTable(_ sender: Any) {
        if self.tableView.isEditing{
            self.tableView.setEditing(false, animated: true)
            editButton.setTitle("Edit".tr(), for: .normal)
        }
        else{
            self.tableView.setEditing(true, animated: true)
            editButton.setTitle("Done".tr(), for: .normal)
        }
        
    }
    
    
    
    func fill(){
        self.title = billData.name == "" ? "New bill".tr() : billData.name
        self.name.text = billData.name
        self.cost.text = billData.cost.formatCurrency(showZero: false)
    }
    
    
    
    @objc func saveButtonAction(){
        billData.name = name.text!
        if let costStr = self.cost.text  {
            billData.cost = costStr.toCurrency()
        }
        presenter.save(billdata: billData)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - UITextFieldDelegate
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = textField.text, value.toCurrency() == 0.0 {
            textField.text = ""
        }
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
        return section == 1 ? 0 : presenter.getMemberInBillCount()
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
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        tableView.separatorStyle = presenter.getMemberInBillCount() > 0 ? .singleLine : .none
        tableView.endUpdates()
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

