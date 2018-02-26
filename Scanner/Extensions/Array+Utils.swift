//
//  Array+Utils.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension Array where Element: CIRectangleFeature {
    
    /// Finds the biggest rectangle within an array of CIRectangleFeature objects.
    func biggestRectangle() -> CIRectangleFeature? {
        guard count > 1 else {
            return first
        }
                
        var biggestRectanglePerimeter: CGFloat = -1
        var biggestRectangle: CIRectangleFeature?
        
        self.forEach { (rectangle) in
            let perimeter = rectangle.perimeter()
            if biggestRectanglePerimeter < perimeter {
                biggestRectanglePerimeter = perimeter
                biggestRectangle = rectangle
            }
        }
        
        return biggestRectangle
    }
    
}
