//
//  UIViewController+Extension.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 09/07/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

protocol StyledView{
    func setupStyle()
}

extension StyledView where Self: UITableViewController {
    
    func setupTableView(){
        self.tableView.backgroundColor = Colors.tableBackground
        self.tableView.separatorColor = Colors.tableSeparator
    }
    
    func setupStyle(){
        setupTableView()
    }
}

extension StyledView where Self: UITableViewCell {

    func setupStyle(){
        self.tintColor = Colors.accessoryCell
    }
}



extension UITableViewController: StyledView{
}

extension UITableViewCell: StyledView{
}


struct Colors{
    static let grayText = UIColor(rgb: 0x625b5f)
    
    static let barAccent = UIColor(rgb: 0x843B62)
    
    static let barText = UIColor.white
    
    static let tableBackground = UIColor.white
    
    static let tableSeparator = UIColor(rgb: 0xD2B7C5)
    
    static let accessoryCell = UIColor(rgb: 0x712F11)
    
    static let oldPage = UIColor(rgb: 0xD2B7C5)
    
    static let sectionText = UIColor(rgb: 0xF67E7D)
    
    static let sectionButton = UIColor(rgb: 0xB35C5B)
    
    static let contentText = UIColor(rgb: 0x0B032D)
}


