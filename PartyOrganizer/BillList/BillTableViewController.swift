//
//  BillTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 21/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class BillTableViewController: UITableViewController {
    
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let billVc = storyboard.instantiateViewController(withIdentifier: "billVc")
            self.navigationController?.pushViewController(billVc, animated: true)
        }
        tableView.backgroundView = emptyTableView
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        return 0
    }
    
    lazy var emptyTableView: EmptyTableMessageView = {
        
        var view = EmptyTableMessageView("Bill")
        return view
    }()

}
