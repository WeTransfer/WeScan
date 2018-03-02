//
//  ShutterButton.swift
//  WeScan
//
//  Created by Boris Emorine on 2/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// A simple button used for the shutter.
final class ShutterButton: UIControl {
    
    private let outterRingLayer = CAShapeLayer()
    private let innerCircleLayer = CAShapeLayer()
    
    private let outterRingRatio: CGFloat = 0.80
    private let innerRingRatio: CGFloat = 0.75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(outterRingLayer)
        layer.addSublayer(innerCircleLayer)
        backgroundColor = .clear
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraitButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        outterRingLayer.frame = rect
        outterRingLayer.path = pathForOutterRing(inRect: rect).cgPath
        outterRingLayer.fillColor = UIColor.white.cgColor
        outterRingLayer.rasterizationScale = UIScreen.main.scale
        outterRingLayer.shouldRasterize = true
        
        innerCircleLayer.frame = rect
        innerCircleLayer.path = pathForInnerCircle(inRect: rect).cgPath
        innerCircleLayer.fillColor = UIColor.white.cgColor
        innerCircleLayer.rasterizationScale = UIScreen.main.scale
        innerCircleLayer.shouldRasterize = true
    }
    
    private func pathForOutterRing(inRect rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: rect)
        
        let innerRect = rect.scaleAndCenter(withRatio: outterRingRatio)
        let innerPath = UIBezierPath(ovalIn: innerRect).reversing()
        
        path.append(innerPath)
        
        return path
    }
    
    private func pathForInnerCircle(inRect rect: CGRect) -> UIBezierPath {
        let rect = rect.scaleAndCenter(withRatio: innerRingRatio)
        let path = UIBezierPath(ovalIn: rect)
        
        return path
    }
    
}
