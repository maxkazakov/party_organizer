//
//  BillTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 21/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import CoreData

class BillTableViewController: UITableViewController, IndicatorInfoProvider, EventPagerBarActionDelegate {
    
    
    static let identifier = String(describing: BillTableViewController.self)
    
    var presenter: BillTablePrenester!
    
    
    // MARK: EventPagerAddAction
    func exetuceAdd(){
        self.routing(with: .createOrEditBill)
    }
    
    func beginEditing(){
        self.tableView.setEditing(true, animated: true)
    }
    
    func endEditing(){
        self.tableView.setEditing(false, animated: true)
    }
    
    private var _isEmpty = true
    
    func isEmpty() -> Bool{
        return _isEmpty
    }
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bills".localize())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        self.presenter.setFetchControllDelegate(delegate: self)
//        tableView.tableHeaderView = tableHeader
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectRow(indexPath)
        self.routing(with: .createOrEditBill)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = presenter.getBillsCount()
        _isEmpty = cnt == 0
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            tableHeader.layer.isHidden = false
        }
        else{
            addNewMemberBtn.callback = {
                [unowned self] in
                self.routing(with: .createOrEditBill)
            }
            tableView.backgroundView = addNewMemberBtn
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillTableViewCell.identifier) as! BillTableViewCell
        let bill = presenter.getBillViewData(indexPath: indexPath)
        cell.setData(name: bill.name, cost: bill.cost, memCount: bill.memberCount)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            presenter.delete(indexPath: indexPath)
        }
    }
    
    private let addNewMemberBtn = AddNewItemButton(type: .bill)
    
    
    lazy var tableHeader: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))

        var label = UILabel(frame: view.frame)
        label.text = "Bills".localize()
        view.addSubview(label)
        return view
        
    }()
    
    
}

extension BillTableViewController: NSFetchedResultsControllerDelegate{
    
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
