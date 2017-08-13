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
    
    init(){
        self.name = ""
        self.cost = 0.0
        self.images =  []
        self.memberCount = 0
    }
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
    
    var billData = BillViewData()
    
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cost: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sectionTf: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    var numericKeyboard: MMNumberKeyboard {
        return MMNumberKeyboard(frame: CGRect.zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        
        self.title = "New bill".localize()
        editButton.tintColor = Colors.sectionButton
        addButton.tintColor = Colors.sectionButton
        sectionTf.textColor = Colors.sectionText
        separatorLine.backgroundColor = UIColor(rgb: 0xB35C5B)
        
        if let billData = presenter.getBillViewData() {
            self.billData = billData
            fill()
        }
        
        if billData.name == "" {
            name.becomeFirstResponder()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
        numericKeyboard.allowsDecimalPoint = true
        self.presenter.setFetchControllDelegate(delegate: self)
        cost.inputView = numericKeyboard
        cost.delegate = self
    }
    
    
    @IBAction func addMember(_ sender: Any) {
        self.routing(with: .selectMembers)
    }
    
    @IBAction func editTable(_ sender: Any) {
        if self.tableView.isEditing{
            self.tableView.setEditing(false, animated: true)
            editButton.setTitle("Edit".localize(), for: .normal)
        }
        else{
            self.tableView.setEditing(true, animated: true)
            editButton.setTitle("Done".localize(), for: .normal)
        }
        
    }
    
    func fill(){
        self.title = billData.name == "" ? "New bill".localize() : billData.name
        self.name.text = billData.name
        self.cost.text = Helper.formatDecimal(value: billData.cost)
    }
    
    @objc func saveButtonAction(){
        billData.name = name.text!
        let cost = Double(self.cost.text!)
        billData.cost = cost ?? 0.0
        presenter.save(billdata: billData)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: -UITextFieldDelegate
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Double(textField.text!) else{
            fatalError("Non a double")
        }
    
        if value < 0.01{
            textField.text = ""
        }
    }
    
    var addNewMemberBtn = AddNewItemButton(type: .member)

}

extension BillViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInBillCell.identifier) as! MemberInBillCell
        let memInBill = presenter.getMemberInBillViewData(indexPath: indexPath)
        cell.delegate = self
        cell.setData(memInBill)
        cell.setInputView(view: numericKeyboard)
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt =  presenter.getMemberInBillCount()
        
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        else{
            addNewMemberBtn.callback = {
                [unowned self] in
                self.routing(with: .selectMembers)
            }
            tableView.backgroundView = addNewMemberBtn
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MemberInBillCell
        cell.select()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.presenter.delete(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
}

extension BillViewController: NSFetchedResultsControllerDelegate{
    
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

extension BillViewController: MemberInBillCellDelegate {
    
    func debtValueDidChange(sender: MemberInBillCell, value: Double) {
        guard let indexPath = self.tableView.indexPath(for: sender) else {
            return
        }
        
        self.presenter.update(indexPath: indexPath, debt: value)
    }
}

