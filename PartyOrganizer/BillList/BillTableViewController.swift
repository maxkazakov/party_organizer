//
//  BillTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 21/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BillTableViewController: UITableViewController, IndicatorInfoProvider {
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Bills")
    }
    
    static let identifier = String(describing: BillTableViewController.self)
    
    let presenter = BillTablePrenester()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        emptyTableView.tap_callback = {
            let storyboard = UIApplication.shared.mainStoryboard
            let billVc = storyboard!.instantiateViewController(withIdentifier: "billVc")
            self.navigationController?.pushViewController(billVc, animated: true)
        }
        tableView.backgroundView = emptyTableView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        emptyTableView.layout()
        
        return 0
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        
        var view = EmptyTableMessageView("Bill", showAddAction: true)
        return view
    }()

}
