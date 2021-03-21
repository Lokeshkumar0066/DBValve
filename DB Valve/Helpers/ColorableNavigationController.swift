//
//  ColorableNavigationController.swift
//
//  Created by Lokesh Kumar on 12/03/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit

/// Navigation bar colors for `ColorableNavigationController`, called on `push` & `pop` actions
public protocol NavigationBarColorable: class {
    var navigationTintColor: UIColor? { get }
    var navigationBarTintColor: UIColor? { get }
}

public extension NavigationBarColorable {
    var navigationTintColor: UIColor? { return nil }
}

/**
UINavigationController with different colors support of UINavigationBar.
To use it please adopt needed child view controllers to protocol `NavigationBarColorable`.
- note: Don't forget to set initial tint and barTint colors
*/
open class ColorableNavigationController: UINavigationController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if let controller = self.viewControllers.first as? NavigationBarColorable {
            self.setNavigationBarColors(controller)
        }
    }
    
    private var previousViewController: UIViewController? {
        guard viewControllers.count > 1 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let colors = viewController as? NavigationBarColorable {
            self.setNavigationBarColors(colors)
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        if let colors = self.previousViewController as? NavigationBarColorable {
            self.setNavigationBarColors(colors)
        }
        
        // Let's start pop action or we can't get transitionCoordinator()
        let popViewController = super.popViewController(animated: animated)
        
        // Secure situation if user cancelled transition
        transitionCoordinator?.animate(alongsideTransition: nil, completion: { [weak self] (context) in
            guard let colors = self?.topViewController as? NavigationBarColorable else { return }
            self?.setNavigationBarColors(colors)
            })
        
        return popViewController
    }
    
    private func setNavigationBarColors(_ colors: NavigationBarColorable) {
        if let tintColor = colors.navigationTintColor {
            self.navigationBar.tintColor = tintColor
        }
        
        if colors.navigationBarTintColor == .clear {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.setValue(true, forKey: "hidesShadow")
            self.navigationBar.isTranslucent = true
            self.view.backgroundColor = .clear
        } else {
            self.navigationBar.barTintColor = colors.navigationBarTintColor
            self.navigationBar.setValue(false, forKey: "hidesShadow")
            self.navigationBar.isTranslucent = false
        }
    }
}
