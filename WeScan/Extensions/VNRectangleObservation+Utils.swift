//
//  VNRectangleObservation+Utils.swift
//  WeScan
//
//  Created by Julian Schiavo on 6/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Vision
import Foundation

@available(iOS 11.0, *)
extension VNRectangleObservation {
    
    /// The perimeter of the quadrilateral.
    func perimeter() -> CGFloat {
        return (topRight.x - topLeft.x) + (topRight.y - bottomRight.y) + (bottomRight.x - bottomLeft.x) + (topLeft.y - bottomLeft.y)
    }
    
}
