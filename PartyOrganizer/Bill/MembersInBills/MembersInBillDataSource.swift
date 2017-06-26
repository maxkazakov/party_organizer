//
//  MembersInBillDataSource.swift
//  PartyOrganizer
//
//  Created by Максим Казаков on 26/06/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

struct MemberInBillViewData {
    var name: String
    var debt: Double

    init(){
        self.name = ""
        self.debt = 0.0
    }
}

class MembersInBillDataSource: NSObject, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemberInBillCell.identifier)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
