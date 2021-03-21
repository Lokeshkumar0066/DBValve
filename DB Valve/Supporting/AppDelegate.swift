//
//  AppDelegate.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 16/02/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit
import Razorpay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        sleep(1)

        return true
    }

}

extension AppDelegate {
    static var instance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
