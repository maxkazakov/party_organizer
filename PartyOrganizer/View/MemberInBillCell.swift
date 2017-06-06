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
        debt.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var debt: UITextField!
    @IBOutlet weak var name: UILabel!
    
    weak var delegate: MemberInBillCellDelegate?
    
    func setData(_ memInBill: MemberInBillViewData){
        self.name.text = memInBill.name
        self.debt.text = String(format: "%.2f", memInBill.debt)
    }
    
    func setInputView(view: UIView){
        self.debt.inputView = view
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
        guard let value = Double(textField.text!) else {
            fatalError("Unexpected debt value")            
        }
        delegate?.debtValueDidChange(sender: self, value: value)
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
