//
//  ContactTableController.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 14/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit

class ContactTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }

}


extension ContactTableController: NavigationBarColorable {
    var navigationBarTintColor: UIColor? {
        return UIColor(red: 255, green: 195, blue: 11)
    }
}
