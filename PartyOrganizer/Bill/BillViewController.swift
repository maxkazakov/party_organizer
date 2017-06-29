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

class MembersSection: UIView {
    var addCallback: (() -> Void)?
    var editCallback: (() -> Void)?
    
    var text: UILabel = {
        let label = UILabel()
        label.text = "Members"
        label.sizeToFit()
        return label
    }()
    
    var addBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return btn
    }()
    
    var editBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Edit", for: .normal)
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        return btn
    }()

    
    func addAction(){
        addCallback?()
    }
    
    func editAction(){
        editCallback?()
    }
    
    init(){
        super.init(frame: CGRect.zero)
//        self.layer.backgroundColor = UIColor.gray.cgColor
        self.addSubview(text)
        self.addSubview(addBtn)
        self.addSubview(editBtn)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let x_magrin: CGFloat = 20
        let y_magrin: CGFloat = 5
        
        text.frame = CGRect(x: x_magrin, y: y_magrin, width: text.frame.width, height: text.frame.height)
        
        addBtn.frame = CGRect(x: self.bounds.width - addBtn.frame.width - x_magrin, y: 0, width: addBtn.frame.width, height: addBtn.frame.height)
        
        editBtn.frame = CGRect(x: addBtn.frame.origin.x - editBtn.frame.width - 15, y: 0, width: editBtn.frame.width, height: editBtn.frame.height)
    }
}


class BillViewController: UITableViewController, MMNumberKeyboardDelegate, UITextFieldDelegate {
    
    static let identifier = String(describing: BillViewController.self)
    
    var presenter: BillPresenter!
    
    var billData = BillViewData()
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cost: UITextField!
    
    let numericKeyboard = MMNumberKeyboard(frame: CGRect.zero)
    
    let section = MembersSection()
    
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
        
        name.delegate = self
        cost.inputView = numericKeyboard
    }
    
    
    func fill(){
        self.name.text = billData.name
        self.cost.text = String(format: "%.2f", billData.cost)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension BillViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInBillCell.identifier) as! MemberInBillCell
        let memInBill = presenter.getMemberInBillViewData(indexPath: indexPath)
        cell.setData(memInBill)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getMemberInBillCount()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.section
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

