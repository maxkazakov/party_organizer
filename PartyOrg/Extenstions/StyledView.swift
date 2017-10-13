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


extension String {
    var color: UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



struct Colors {    
    static let contactColors: [UIColor] = [
        "#912c4e".color,
        "#9c17ad".color,
        "#5c13bd".color,
        "#0b0cb7".color,
        "#64bbc8".color,
        
        "#650400".color,
        "#e8053e".color,
        "#2234cb".color,
        "#680682".color,
        "#165482".color,
        
        "#00bfff".color,
        "#ff80a6".color,
        "#ff331a".color,
        "#ffbf00".color,
        
        "#34315c".color,
        "#8076b6".color,
        "#57568f".color,
        "#baa4e1".color,
        "#a1b7ea".color
    ]
    
    
    
    
    static let darkGrey = "333333".color
    
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


