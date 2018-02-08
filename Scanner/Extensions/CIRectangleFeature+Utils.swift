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
}

