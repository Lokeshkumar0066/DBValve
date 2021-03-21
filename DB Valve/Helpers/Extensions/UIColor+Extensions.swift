//
//  UIColor+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 04/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     Creates a UIColor object for the given rgb value which can be specified
     as HTML hex color value. For example:
     
     let color = UIColor(rgb: 0x8046A2)
     let colorWithAlpha = UIColor(rgb: 0x8046A2, alpha: 0.5)
     
     - parameter rgb: color value as Int. To be specified as hex literal like 0xff00ff
     - parameter alpha: alpha optional alpha value (default 1.0)
     */
    
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((rgb & 0xff0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00ff00) >>  8) / 255
        let b = CGFloat((rgb & 0x0000ff)      ) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        let r = CGFloat(red) / 255
        let g = CGFloat(green) / 255
        let b = CGFloat(blue) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

