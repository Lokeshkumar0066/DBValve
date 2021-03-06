//
//  MKActivityIndicator.swift
//  ProFive
//
//  Created by Lokesh Kumar on 25/08/17.
//  Copyright © 2017 Lokesh Kumar. All rights reserved.
//

import UIKit

@IBDesignable
public class MKActivityIndicator: UIView {
    
    private let drawableLayer = CAShapeLayer()
    var animating = false
    
    @IBInspectable public var color: UIColor = UIColor(hex: 0x2196F3) {
        didSet {
            drawableLayer.strokeColor = self.color.cgColor
        }
    }
    
    @IBInspectable public var lineWidth: CGFloat = 6 {
        didSet {
            drawableLayer.lineWidth = self.lineWidth
            self.updatePath()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }
    
    public func startAnimating() {
        if self.animating {
            return
        }
        
        self.animating = true
        self.isHidden = false
        self.resetAnimations()
    }
    
    public func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        self.animating = false
        self.isHidden = true
    }
    
    private func setup() {
        self.isHidden = true
        self.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = self.color.cgColor
        self.drawableLayer.lineWidth = self.lineWidth
        self.drawableLayer.fillColor = UIColor.clear.cgColor
        self.drawableLayer.lineCap = .round
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }
    
    private func updateFrame() {
        self.drawableLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    private func updatePath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.width, self.bounds.height) / 2 - self.lineWidth
        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: true)
            .cgPath
    }
    
    private func resetAnimations() {
        drawableLayer.removeAllAnimations()
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = 2 * Double.pi
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.isRemovedOnCompletion = false
        
        let startHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        startHeadAnim.beginTime = 0.1
        startHeadAnim.fromValue = 0
        startHeadAnim.toValue = 0.25
        startHeadAnim.duration = 1
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        startTailAnim.beginTime = 0.1
        startTailAnim.fromValue = 0
        startTailAnim.toValue = 1
        startTailAnim.duration = 1
        startTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnim.beginTime = 1
        endHeadAnim.fromValue = 0.25
        endHeadAnim.toValue = 0.99
        endHeadAnim.duration = 0.5
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnim.beginTime = 1
        endTailAnim.fromValue = 1
        endTailAnim.toValue = 1
        endTailAnim.duration = 0.5
        endTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let strokeAnimGroup = CAAnimationGroup()
        strokeAnimGroup.duration = 1.5
        strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
        strokeAnimGroup.repeatCount = Float.infinity
        strokeAnimGroup.isRemovedOnCompletion = false
        
        self.drawableLayer.add(rotationAnim, forKey: "rotation")
        self.drawableLayer.add(strokeAnimGroup, forKey: "stroke")
    }
}
