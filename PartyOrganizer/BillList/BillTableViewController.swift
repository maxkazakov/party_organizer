//
//  BillTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 21/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BillTableViewController: UITableViewController, IndicatorInfoProvider, EventPagerAddAction {
    
    
    static let identifier = String(describing: BillTableViewController.self)
    
    let presenter = BillTablePrenester()
    
    
    // MARK: EventPagerAddAction
    func exetuce(){
        let memberVc = self.createBillVc()
        self.navigationController?.pushViewController(memberVc, animated: true)
    }
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bills")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.tableHeaderView = tableHeader
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let billVc = self.createBillVc()
        billVc.presenter.bill = self.presenter.getBill(index: indexPath.row)
        self.navigationController?.pushViewController(billVc, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = presenter.getBillsCount()
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            tableHeader.layer.isHidden = false
        }
        else{
            emptyTableView.tap_callback = {
                [unowned self] in
                let billVc = self.createBillVc()
                self.navigationController?.pushViewController(billVc, animated: true)
            }
            tableView.backgroundView = emptyTableView
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            emptyTableView.layout()
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillTableViewCell.identifier) as! BillTableViewCell
        let bill = presenter.getBillViewData(index: indexPath.row)
        cell.setData(name: bill.name, cost: bill.cost)
        return cell
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        
        var view = EmptyTableMessageView("Bill", showAddAction: true)
        return view
    }()
    
    func createBillVc() -> BillViewController {
        let storyboard = UIApplication.shared.mainStoryboard
        let res = storyboard!.instantiateViewController(withIdentifier: BillViewController.identifier) as! BillViewController
        res.presenter.event = self.presenter.event
        return res
    }
    
    lazy var tableHeader: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        //        view.layer.backgroundColor = UIColor.purple.cgColor
        var label = UILabel(frame: view.frame)
        label.text = "Bills"
        view.addSubview(label)
        return view
        
    }()

}
