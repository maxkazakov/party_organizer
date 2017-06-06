//
//  MemberTableViewController.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 22/05/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol MemberTableViewControllerDelegate: class{
    func didMemberSelected(member: Member)
}

class MemberTableViewController: UITableViewController, IndicatorInfoProvider, EventPagerAddAction {
    
    static let identifier = String(describing: MemberTableViewController.self)
    
    // MARK: IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Members")
    }
    
    var checkableMode: Bool = false
    weak var delegate: MemberTableViewControllerDelegate?
    
    // MARK: Outlets
    
    let presenter = MemberTablePrenester()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkableMode{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectItems))
            
            self.title = "Members selection"
        }
//        tableView.tableHeaderView = tableHeader
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
        let res = storyboard!.instantiateViewController(withIdentifier: MemberViewController.identifier) as! MemberViewController
        res.presenter.event = self.presenter.event
        return res
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let cnt = presenter.getMembersCount()
        
        if !checkableMode {
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
                emptyTableView.layout()
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
                tableHeader.layer.isHidden = true
            }
        }

        
        return cnt
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkableMode{
            let cell = tableView.cellForRow(at: indexPath) as! MemberCheckableViewCell
            cell.checkToggle()
        }
        else{
            let memberVc = self.createMemberVc()
            memberVc.presenter.member = self.presenter.getMember(index: indexPath.row)
            self.navigationController?.pushViewController(memberVc, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let member = presenter.getMemberViewData(index: indexPath.row)
        
        if checkableMode{
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberCheckableViewCell.identifier, for: indexPath)
                as! MemberCheckableViewCell
            cell.name.text = member.name
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identifier, for: indexPath)
                as! MemberTableViewCell
            cell.name.text = member.name
            return cell
        }
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
    

    
    // MARK: EventTabbarAddAction
    func exetuce(){
        let memberVc = self.createMemberVc()
        
        self.navigationController?.pushViewController(memberVc, animated: true)
    }
    
    @objc func selectItems(){
        if let delegate = self.delegate{
            for cell in self.tableView.visibleCells{
                let memCell = cell as! MemberCheckableViewCell
                if memCell.checked{
                    guard let indexPath = self.tableView.indexPath(for: cell) else{
                        continue
                    }
                    let member = self.presenter.getMember(index: indexPath.row)
                    delegate.didMemberSelected(member: member)
                }
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}
