//
//  BillViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 29/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import MMNumberKeyboard

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

class BillViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MMNumberKeyboardDelegate, UITextFieldDelegate, MemberInBillCellDelegate{
    
    static let identifier = String(describing: BillViewController.self)
    
    var presenter = BillPresenter()
    var billData = BillViewData()
    var memsInBills: [MemberInBillViewData]!
    
    @IBOutlet weak var photoCollection: UICollectionView!
    
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var photoCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cost: UITextField!
    
    let numericKeyboard = MMNumberKeyboard(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title = "New bill"
        self.photoCollection.delegate = self
        self.photoCollection.dataSource = self
        self.photoCollection.layer.borderWidth = 1.0
        if let billData = presenter.getBillViewData(){
            self.billData = billData
            fill()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonAction))
        
        numericKeyboard.allowsDecimalPoint = true
//        numericKeyboard.delegate = self
        
        name.delegate = self
        cost.inputView = numericKeyboard
            
        memsInBills = presenter.getMembersinBillViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func fill(){
        self.name.text = billData.name
        self.cost.text = String(format: "%.2f", billData.cost)
    }
    
    @IBAction func addNewPhoto(_ sender: Any) {
        photoCollection.resignFirstResponder()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        if let pathArr = photoCollection.indexPathsForSelectedItems{
            guard pathArr.count > 0 else {
                return
            }
            let idx = pathArr[0]
            billData.images.remove(at: idx.row)
            photoCollection.deleteItems(at: [idx])
        }
    }
    
    
    @IBAction func addMember(_ sender: Any) {
        let storyboard = UIApplication.shared.mainStoryboard
        
        let membersVc = storyboard!.instantiateViewController(withIdentifier: MemberTableViewController.identifier) as! MemberTableViewController
        membersVc.presenter.event = self.presenter.event
        membersVc.presenter.exclude(members: self.presenter.members)
        membersVc.checkableMode = true
        membersVc.delegate = self
        
        self.navigationController?.pushViewController(membersVc, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Members"
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInBillCell.identifier, for: indexPath) as! MemberInBillCell
        
        let memInBill = memsInBills[indexPath.row]
        cell.setData(memInBill)
        cell.setInputView(view: numericKeyboard)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete{
//            events.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memsInBills.count
    }
    
    // MARK: - CollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cnt = billData.images.count
        return cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollection.dequeueReusableCell(withReuseIdentifier: "BillImageCell", for: indexPath) as! BillImageViewCell
        let idx = indexPath.row
        cell.setImage(billData.images[idx])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BillImageViewCell
        cell.setSelectedBorder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BillImageViewCell
        cell.setDefaultBorder()
    }
    
    
    // MARK: - ImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImg = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let idxPath = IndexPath(row: billData.images.count, section: 0)
        billData.images.append(selectedImg)
        dismiss(animated: true, completion: nil)
        photoCollection.insertItems(at: [idxPath])        
    }

    @objc func saveButtonAction(){
        billData.name = name.text!
        let cost = Double(self.cost.text!)
        billData.cost = cost ?? 0.0
        presenter.save(billdata: billData, membersdata: memsInBills)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: MemberInBillCellDelegate
    func debtValueDidChange(sender: MemberInBillCell, value: Double) {
        guard let indexPath = tableView.indexPath(for: sender) else{
            return
        }
        
        self.memsInBills[indexPath.row].debt = value
        
    }
}

extension BillViewController: MemberTableViewControllerDelegate{
    func didMemberSelected(member: Member) {
        self.presenter.addMember(member: member)
        var memData = MemberInBillViewData()
        memData.name = member.name ?? "error member"
        self.memsInBills.append(memData)
    }
}
