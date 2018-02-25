//
//  CIRectangleFeature+Utils.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

extension CIRectangleFeature {
    
    func perimeter() -> CGFloat {
        return (topRight.x - topLeft.x) + (bottomRight.y - topRight.y) + (bottomRight.x - bottomLeft.x) + (bottomLeft.y - topLeft.y)
    }
    
    func isWithin(_ distance: CGFloat, ofRectangleFeature rectangleFeature: CIRectangleFeature) -> Bool {
        
        let topLeftRect = topLeft.surroundingSquare(withSize: distance)
        if !topLeftRect.contains(rectangleFeature.topLeft) {
            return false
        }
        
        let topRightRect = topRight.surroundingSquare(withSize: distance)
        if !topRightRect.contains(rectangleFeature.topRight) {
            return false
        }
        
        let bottomRightRect = bottomRight.surroundingSquare(withSize: distance)
        if !bottomRightRect.contains(rectangleFeature.bottomRight) {
            return false
        }

        let bottomLeftRect = bottomLeft.surroundingSquare(withSize: distance)
        if !bottomLeftRect.contains(rectangleFeature.bottomLeft) {
            return false
        }
        
        return true
    }
    
    override open var description: String {
        return "topLeft: \(topLeft), topRight: \(topRight), bottomRight: \(bottomRight), bottomLeft: \(bottomLeft)"
    }
    
}

