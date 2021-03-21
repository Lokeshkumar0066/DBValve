//
//  HomeVC.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 16/02/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit
import EasyTipView

enum MenuType {
    case Cross, About, Media, WhyChooseUs, Complaint, Contact, Enquiry
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optionButton: UIBarButtonItem!
    
    private var contextMenuTableView: YALContextMenuTableView?
    private var tipView: EasyTipView?

    private var menuItems: [(icon: String, name: String, type: MenuType)] = []
    private var dataSet = DataModel.getDatSet() ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let cellNib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "ItemTableViewCell")
        
        self.menuItems = [
            ("cross", "", .Cross),
            ("aboutUsIcon", "About Us", .About),
            //("eyes", "Media", .Media),
            ("userNew", "Why Choose Us", .WhyChooseUs),
            ("complaints", "Register Complaint", .Complaint),
            ("call", "Contact Us", .Contact),
            ("enquiry", "Enquiry", .Enquiry),
        ]
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont.systemFont(ofSize: 18)
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor(hue:0.46, saturation:0.99, brightness:0.6, alpha:1)
        preferences.positioning.maxWidth = 250

        EasyTipView.globalPreferences = preferences

        let text = "To make query regaring any product enquiry, or registering any complaint Please click above."
        tipView = EasyTipView(text: text, preferences: preferences, delegate: nil)
        tipView?.show(animated: true, forItem: self.optionButton, withinSuperView: self.navigationController?.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        tipView?.dismiss()
    }
    
    //MARK: Side Menu Call
    @IBAction func optionButtonAction(_ sender: Any) {
        tipView?.dismiss()
        var notInitial = true
        if (self.contextMenuTableView == nil) {
            self.contextMenuTableView = YALContextMenuTableView(tableViewDelegateDataSource: self)
            self.contextMenuTableView?.animationDuration = 0.15
            //optional - implement custom YALContextMenuTableView custom protocol
            self.contextMenuTableView?.yalDelegate = self;
            //optional - implement menu items layout
            self.contextMenuTableView?.menuItemsSide = .Right;
            self.contextMenuTableView?.menuItemsAppearanceDirection = .FromTopToBottom;
            
            //register nib
            let cellNib = UINib(nibName: "ContextMenuCell", bundle: nil)
            self.contextMenuTableView?.register(cellNib, forCellReuseIdentifier: "rotationCell")
            
            notInitial = false
        }
        
        // it is better to use this method only for proper animation
        self.contextMenuTableView?.show(in: self.navigationController?.view, with: .zero, animated: notInitial)
    }
    
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return dataSet.count
        } else {
            return self.menuItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return 150
            case .pad:
                return 250
            default:
                return 200
            }
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as! ItemTableViewCell
            
            let item = self.dataSet[indexPath.row]
            cell.itemImageView.image = UIImage(named: item.images)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rotationCell") as! ContextMenuCell
            cell.selectionStyle =  .none
            
            let item = self.menuItems[indexPath.row]
            cell.menuTitleLabel.text = item.name
            cell.menuImageView.image = UIImage(named: item.icon)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tipView?.dismiss()
      
        if tableView == self.tableView {
            let item = self.dataSet[indexPath.row]
            if let _ = item.child {
                let vc = DetailProductTableController.instantiate(fromAppStoryboard: .Main)
                vc.dataItem = item
                self.navigationController?.pushViewController(vc, animated: true)
            } else if let _ = item.url {
                let vc = WebViewController.instantiate(fromAppStoryboard: .Main)
                vc.item = item
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.contextMenuTableView?.dismis(with: indexPath)
        }
    }
    
}

extension HomeVC: YALContextMenuTableViewDelegate {
    
    func contextMenuTableView(_ contextMenuTableView: YALContextMenuTableView!, didDismissWith indexPath: IndexPath!) {
        
        let menuItem = self.menuItems[indexPath.row]
        switch menuItem.type {
        case .About, .WhyChooseUs:
            let vc = AboutUsVC.instantiate(fromAppStoryboard: .Main)
            vc.type = self.menuItems[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .Complaint:
            let vc = WebViewController.instantiate(fromAppStoryboard: .Main)
            vc.item = DataModel(name: menuItem.name, images: "", child: nil, url: "http://www.dbvalves.com/mobile-complaint.html")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .Enquiry:
            let vc = WebViewController.instantiate(fromAppStoryboard: .Main)
            vc.item = DataModel(name: menuItem.name, images: "", child: nil, url: "http://www.dbvalves.com/mobile-contact.html")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .Contact:
            let vc = ContactTableController.instantiate(fromAppStoryboard: .Main)
            vc.title = menuItem.name
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }
}

extension HomeVC: NavigationBarColorable {
    var navigationBarTintColor: UIColor? {
        return UIColor.clear
    }
}
