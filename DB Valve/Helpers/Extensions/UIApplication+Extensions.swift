//
//  UIApplication+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 02/04/18.
//  Copyright © 2018 Lokesh Kumar. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}





extension UIViewController {
    
    func shareActivity(_ items: [Any], from sourceView: Any?) {

        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let view = sourceView as? UIBarButtonItem {
            activityViewController.popoverPresentationController?.barButtonItem = view
        } else if let view = sourceView as? UIView {
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.popoverPresentationController?.sourceRect = view.bounds
        } else {
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
