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
        
        let topLeftRect = topLeft.surroundingRect(withDistance: distance)
        if !topLeftRect.contains(rectangleFeature.topLeft) {
            return false
        }
        
        let topRightRect = topRight.surroundingRect(withDistance: distance)
        if !topRightRect.contains(rectangleFeature.topRight) {
            return false
        }
        
        let bottomRightRect = bottomRight.surroundingRect(withDistance: distance)
        if !bottomRightRect.contains(rectangleFeature.bottomRight) {
            return false
        }

        let bottomLeftRect = bottomLeft.surroundingRect(withDistance: distance)
        if !bottomLeftRect.contains(rectangleFeature.bottomLeft) {
            return false
        }
        
        return true
    }
}

