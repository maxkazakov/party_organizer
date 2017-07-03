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
    
    init(){
        self.name = ""
        self.cost = 0.0
        self.images =  []
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
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cost: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    var numericKeyboard: MMNumberKeyboard {
        return MMNumberKeyboard(frame: CGRect.zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New bill"
        //        self.photoCollection.delegate = self
        //        self.photoCollection.dataSource = self
        //        self.photoCollection.layer.borderWidth = 0.0
        if let billData = presenter.getBillViewData(){
            self.billData = billData
            fill()
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
            editButton.setTitle("Edit", for: .normal)
        }
        else{
            self.tableView.setEditing(true, animated: true)
            editButton.setTitle("Done", for: .normal)
        }
        
    }
    
    func fill(){
        self.title = billData.name == "" ? "New bill" : billData.name
        self.name.text = billData.name
        self.cost.text = billData.cost < 0.01 ? "" : String(format: "%.2f", billData.cost)
    }
    
//        @IBAction func addNewPhoto(_ sender: Any) {
//            photoCollection.resignFirstResponder()
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = .photoLibrary
//            imagePicker.delegate = self
//            present(imagePicker, animated: true, completion: nil)
//        }
//    
//        @IBAction func deletePhoto(_ sender: Any) {
//            if let pathArr = photoCollection.indexPathsForSelectedItems{
//                guard pathArr.count > 0 else {
//                    return
//                }
//                let idx = pathArr[0]
//                billData.images.remove(at: idx.row)
//                photoCollection.deleteItems(at: [idx])
//            }
//        }
    
    @objc func saveButtonAction(){
        billData.name = name.text!
        let cost = Double(self.cost.text!)
        billData.cost = cost ?? 0.0
        presenter.save(billdata: billData)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Double(textField.text!) else{
            fatalError("Non a double")
        }
    
        if value < 0.01{
            textField.text = ""
        }
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        var view = EmptyTableMessageView("Members", showAddAction: true)
        return view
    }()
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
            emptyTableView.tap_callback = {
                [unowned self] in
                self.routing(with: .selectMembers)
            }
            tableView.backgroundView = emptyTableView
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            emptyTableView.layout()
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

extension BillViewController: MemberInBillCellDelegate{
    func debtValueDidChange(sender: MemberInBillCell, value: Double){
        guard let indexPath = self.tableView.indexPath(for: sender) else{
            return
        }
        
        self.presenter.update(indexPath: indexPath, debt: value)
    }
}

//extension BillViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    // MARK: - CollectionViewDelegate
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let cnt = billData.images.count
//        return cnt
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "BillImageCell", for: indexPath) as! BillImageViewCell
//        let idx = indexPath.row
//        cell.setImage(billData.images[idx])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! BillImageViewCell
//        cell.setSelectedBorder()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! BillImageViewCell
//        cell.setDefaultBorder()
//    }
//}
//
//extension BillViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    // MARK: - ImagePickerControllerDelegate
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
//        guard let selectedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else{
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        let idxPath = IndexPath(row: billData.images.count, section: 0)
//        billData.images.append(selectedImg)
//        dismiss(animated: true, completion: nil)
//        photoCollection.insertItems(at: [idxPath])
//    }
//
//}

