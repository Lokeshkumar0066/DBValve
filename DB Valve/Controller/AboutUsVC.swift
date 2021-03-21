//
//  AboutUsVC.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 12/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit

class AboutUsVC: UITableViewController {

    var type: (icon: String, name: String, type: MenuType)!

    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.title = type.name
        
        switch type.type {
        case .About:
            self.descLabel.text = "We are a company that steer ahead show a clear sense of purpose and core values. We interpret them into action and ensure that we are reflected throughout in everything we do. We are dedicated to improving the level of gracious living in the lives of all who are touched by our products and services identifies a clear sense of purpose for us. Continued success emerges from a clear sense of purpose and a corporate culture which promotes living on the leading edge, meshing Art and advanced technology to create new products, new markets and new niches within existing markets, maintaining a high standard of quality in all products and services to make them capable of delighting the senses and sensibility of end users consistently and continually reinvesting the majority of our earnings in operational excellence. These principles drive our long-term success and character Yet, our journey cannot be explained here in totality. Human energy is required to give life and direction to a mission."
            
        case .WhyChooseUs:
            self.descLabel.text = "What we have achieved, in part, is the freedom to think long-term and for whom relationships matter. Our leaders are strong, self-reliant, never short of original ideas, and possess the courage to expand, diversify, and take necessary risks to achieve our objectives. That courage is visible in such unconventional decisions. Our assortment of products comprise the finest ranges & our team includes proven professionals, charged with inspiring and empowering all to enhancing the level of gracious living for everyone touched by our products and services."
        default:
            break
        }
        
    }

}

extension AboutUsVC: NavigationBarColorable {
    var navigationBarTintColor: UIColor? {
        return UIColor(red: 255, green: 195, blue: 11)
    }
}
