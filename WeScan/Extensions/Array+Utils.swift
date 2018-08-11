//
//  Array+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension Array where Element: CIRectangleFeature {
    
    /// Finds the biggest rectangle within an array of `CIRectangleFeature` objects.
    func biggest() -> CIRectangleFeature? {
        return self.max { $0.perimeter() < $1.perimeter() }
    }
    
}
