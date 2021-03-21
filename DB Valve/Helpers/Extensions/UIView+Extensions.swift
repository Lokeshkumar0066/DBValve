//
//  UIView+Extensions.swift
//  ProFive
//
//  Created by Lokesh Kumar on 04/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            guard let color = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

extension UIView {
    class func viewFromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    class func loadNib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle.main)
    }
}


extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        var tableViewcell : UIView? = self
        while(tableViewcell != nil)
        {
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }
    
    
    func tableViewIndexPath(_ tableView: UITableView) -> IndexPath? {
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell)
        }
        else {
            return nil
        }
    }
    
    
    func collectionviewCell() -> UICollectionViewCell? {
        var collectionviewCell : UIView? = self
        while(collectionviewCell != nil)
        {
            if collectionviewCell! is UICollectionViewCell {
                break
            }
            collectionviewCell = collectionviewCell!.superview
        }
        return collectionviewCell as? UICollectionViewCell
    }
    
    
    func collectionViewIndexPath(_ collectionView: UICollectionView) -> IndexPath? {
        if let cell = self.collectionviewCell() {
            return collectionView.indexPath(for: cell)
        }
        else {
            return nil
        }
    }
    
}



extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set {
            self.frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set {
            self.frame.origin.y = newValue
        }
    }
    
    var midX: CGFloat {
        return self.frame.midX
    }
    
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var midY: CGFloat {
        return self.frame.midY
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        } set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        } set {
            self.frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set {
            self.frame.size = newValue
        }
    }
    
}

extension UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
}

extension UILabel {
    
    func manageBlendedLayers() {
        self.isOpaque = true
        self.backgroundColor = UIColor.white
    }

}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)
    }
}

extension UIView {
    
    func shakeView() {
        let shake = CABasicAnimation(keyPath: "position")
        let xDelta = CGFloat(5)
        shake.duration = 0.09
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point = CGPoint(x: self.center.x - xDelta, y: self.center.y)
        let from_value = NSValue(cgPoint: from_point)
        
        let to_point = CGPoint(x: self.center.x + xDelta, y: self.center.y)
        let to_value = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        shake.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(shake, forKey: "position")
    }
}
