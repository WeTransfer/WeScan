//
//  CIRectangleFeature+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

extension CIRectangleFeature {
    
    /// The perimeter of the quadrilateral.
    func perimeter() -> CGFloat {
        return (topRight.x - topLeft.x) + (topRight.y - bottomRight.y) + (bottomRight.x - bottomLeft.x) + (topLeft.y - bottomLeft.y)
    }
    
    /// Checks whether the quadrilateral is withing a given distance of another quadrilateral.
    ///
    /// - Parameters:
    ///   - distance: The distance (threshold) to use for the condition to be met.
    ///   - rectangleFeature: The other rectangle to compare this instance with.
    /// - Returns: True if the given rectangle is within the given distance of this rectangle instance.
    func isWithin(_ distance: CGFloat, ofRectangleFeature rectangleFeature: CIRectangleFeature) -> Bool {
        let keypaths: [KeyPath<CIRectangleFeature, CGPoint>] = [\.topLeft, \.topRight, \.bottomLeft, \.bottomRight]
        // now doing this with all keypaths from `keypaths` array above starting from `topLeft`
        // topLeft.surroundingSquare(withSize: distance).contains(rectangleFeature.topLeft)
        // results are stored into boolean array `flags`
        let flags: [Bool] = keypaths.map { self[keyPath: $0].surroundingSquare(withSize: distance).contains(rectangleFeature[keyPath: $0]) }
        return flags.reduce(true, { $0 && $1}) // runs AND on all `flags` array elements
    }
    
    override open var description: String {
        return "topLeft: \(topLeft), topRight: \(topRight), bottomRight: \(bottomRight), bottomLeft: \(bottomLeft)"
    }
    
}
