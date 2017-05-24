//
//  MemberTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

struct MemberViewData{
    var name: String
    
}

class MemberTableViewController: UITableViewController, EventTabbarAddAction {
    
    // MARK: Outlets

    
    let presenter = MemberTablePrenester()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = tableHeader
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createMemberVc() -> MemberViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let res = storyboard.instantiateViewController(withIdentifier: "memberVc") as! MemberViewController
        res.presenter.event = self.presenter.event
        return res
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let cnt = presenter.getMembersCount()
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            tableHeader.layer.isHidden = true
        }
        else{
            emptyTableView.tap_callback = {
                let memberVc = self.createMemberVc()
                self.navigationController?.pushViewController(memberVc, animated: true)
            }
            tableView.backgroundView = emptyTableView
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableHeader.layer.isHidden = true

        }
        
        return cnt
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let member = presenter.getMemberViewData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberTableViewCell
        cell.name.text = member.name
        
        return cell
     }
 

    
    lazy var emptyTableView: EmptyTableMessageView = {
        
        var view = EmptyTableMessageView("Member")
        return view
    }()
    
    lazy var tableHeader: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        view.layer.backgroundColor = UIColor.purple.cgColor
        var label = UILabel(frame: view.frame)
        label.text = "Members"
        view.addSubview(label)
        return view

    }()
    
    // MARK: EventTabbarAddAction
    func exetuce(){
        let memberVc = self.createMemberVc()
        
        self.navigationController?.pushViewController(memberVc, animated: true)
    }

}
