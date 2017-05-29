//
//  MemberTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct MemberViewData{
    var name: String
    
}

class MemberTableViewController: UITableViewController, IndicatorInfoProvider, EventTabbarAddAction {
    
    static let identifier = String(describing: MemberTableViewController.self)
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Members")
    }
    
    // MARK: Outlets
    
    let presenter = MemberTablePrenester()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = tableHeader
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createMemberVc() -> MemberViewController {
        let storyboard = UIApplication.shared.mainStoryboard
        let res = storyboard!.instantiateViewController(withIdentifier: "memberVc") as! MemberViewController
        res.presenter.event = self.presenter.event
        return res
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = presenter.getMembersCount()
        if cnt > 0{
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            tableHeader.layer.isHidden = false
        }
        else{
            emptyTableView.tap_callback = {
                [unowned self] in
                let memberVc = self.createMemberVc()
                self.navigationController?.pushViewController(memberVc, animated: true)
            }
            tableView.backgroundView = emptyTableView
            tableView.backgroundColor = UIColor.blue
            emptyTableView.layout()
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableHeader.layer.isHidden = true
        }
        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memberVc = self.createMemberVc()        
        memberVc.presenter.member = self.presenter.getMember(index: indexPath.row)
        self.navigationController?.pushViewController(memberVc, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let member = presenter.getMemberViewData(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberTableCell", for: indexPath)
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
