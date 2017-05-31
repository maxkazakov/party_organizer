//
//  BillViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 29/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

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
}

class BillViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    static let identifier = String(describing: BillViewController.self)
    
    var presenter = BillPresenter()
    var billData = BillViewData()
    
    @IBOutlet weak var photoCollection: UICollectionView!
    
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var photoCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var cost: UITextField!
    
       
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
        presenter.save(billdata: billData)
        navigationController?.popViewController(animated: true)
    }
}
