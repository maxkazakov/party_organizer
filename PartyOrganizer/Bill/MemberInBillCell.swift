//
//  MemberInBillCell.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 01/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import MMNumberKeyboard

protocol MemberInBillCellDelegate: class{
    func debtValueDidChange(sender: MemberInBillCell, value: Double)
}

class MemberInBillCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = String(describing: MemberInBillCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        debtTf.delegate = self
    }
    
    @IBOutlet weak var debtTf: UITextField!
    @IBOutlet weak var name: UILabel!
    
    weak var delegate: MemberInBillCellDelegate?
    
    func setData(_ memInBill: MemberInBillViewData){
        self.name.text = memInBill.name
        let val = memInBill.debt < 0.01 ? "" : String(format: "%.2f", memInBill.debt)
        self.debtTf.text = val

    }
    
    func setInputView(view: UIView){
        self.debtTf.inputView = view
    }
    
    func select(){
        self.debtTf.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = Double(textField.text!){
            delegate?.debtValueDidChange(sender: self, value: value)
        }
        else{
            delegate?.debtValueDidChange(sender: self, value: 0)
        }
    }
}

extension MemberInBillCell: MMNumberKeyboardDelegate{
    public func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool{
//        guard let value = Double(self.debt.text!) else {
//            fatalError("Unexpected debt value")
//        }
//        self.delegate?.debtValueDidChange(sender: self, value: value)
        return true
    }
}
