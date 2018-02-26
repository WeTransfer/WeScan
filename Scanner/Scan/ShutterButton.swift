//
//  ShutterButton.swift
//  Scanner
//
//  Created by Boris Emorine on 2/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

class ShutterButton: UIControl {
    
    let circleLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(circleLayer)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        circleLayer.frame = rect
        let path = CGPath(ellipseIn: rect, transform: nil)
        circleLayer.path = path
        circleLayer.fillColor = UIColor.white.cgColor
    }
 
}
