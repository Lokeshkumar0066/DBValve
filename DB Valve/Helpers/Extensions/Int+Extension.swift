//
//  Int+Extension.swift
//  ProFive
//
//  Created by Lokesh Kumar on 22/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

import CoreGraphics

extension Int {
    
    var stringValue: String {
        return "\(self)"
    }
}

extension Double {
    
    var stringValue: String {
        return "\(self)"
    }
}



extension CGFloat {
    var int: Int {
        return Int(self)
    }
}
