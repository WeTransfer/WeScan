//
//  Quadrilateral.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

struct Quadrilateral {
    
    var topLeft: CGPoint
    
    var topRight: CGPoint
    
    var bottomRight: CGPoint
    
    var bottomLeft: CGPoint
    
    init(rectagleFeature: CIRectangleFeature) {
        self.topLeft = rectagleFeature.topLeft
        self.topRight = rectagleFeature.topRight
        self.bottomLeft = rectagleFeature.bottomLeft
        self.bottomRight = rectagleFeature.bottomRight
    }
    
    init(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    func path() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        return path
    }
    
    func applying(_ t: CGAffineTransform) -> Quadrilateral {
        let quadrilateral = Quadrilateral(topLeft: topLeft.applying(t), topRight: topRight.applying(t), bottomRight: bottomRight.applying(t), bottomLeft: bottomLeft.applying(t))
        
        return quadrilateral
    }
    
}
