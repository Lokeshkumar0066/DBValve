//
//  DetailProductTableController.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 03/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit

class DetailProductTableController: UITableViewController {
    
    var dataItem: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = dataItem.name
        
        let cellNib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "ItemTableViewCell")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataItem.child?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 150
        case .pad:
            return 250
        default:
            return 200
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
        
        let item = self.dataItem.child![indexPath.row]
        cell.itemImageView.image = UIImage(named: item.images)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let item = self.dataItem.child?[indexPath.row]
        if let _ = item?.child {
            let vc = DetailProductTableController.instantiate(fromAppStoryboard: .Main)
            vc.dataItem = item
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let _ = item?.url {
            let vc = WebViewController.instantiate(fromAppStoryboard: .Main)
            vc.item = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension DetailProductTableController: NavigationBarColorable {
    var navigationBarTintColor: UIColor? {
        return UIColor(red: 255, green: 195, blue: 11)
    }
}
