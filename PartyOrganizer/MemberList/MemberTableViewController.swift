//
//  MemberTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import CoreData
import XLPagerTabStrip


class MemberTableViewController: UITableViewController, IndicatorInfoProvider, EventPagerBarActionDelegate {
    
    static let identifier = String(describing: MemberTableViewController.self)
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Members")
    }
    
    // MARK: Outlets
    
    var presenter: MemberTablePrenester!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.setFetchControllDelegate(delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = presenter.getMembersCount()
        _isEmpty = cnt == 0
        
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            tableHeader.layer.isHidden = false
        }
        else{
            emptyTableView.tap_callback = {
                [unowned self] in
                self.routing(with: .createOrEditMember)
            }
            tableView.backgroundView = emptyTableView
            emptyTableView.layout()
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableHeader.layer.isHidden = true
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.selectRow(indexPath)
        self.routing(with: .createOrEditMember)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member = presenter.getMemberViewData(indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier, for: indexPath)
            as! MemberTableViewCell
        cell.name.text = member.name
        return cell
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        var view = EmptyTableMessageView("Member", showAddAction: true)
        return view
    }()
    
    lazy var tableHeader: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
//        view.layer.backgroundColor = UIColor.purple.cgColor
        var label = UILabel(frame: view.frame)
        label.text = "Members"
        view.addSubview(label)
        return view

    }()
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.presenter.delete(indexPath: indexPath)
        }
    }
    
    // MARK: EventTabbarAddAction
    
    func exetuceAdd(){
        routing(with: .createOrEditMember)
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
    
}

extension MemberTableViewController: NSFetchedResultsControllerDelegate{
    
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
