//
//  CGPoint+Utils.swift
//  Scanner
//
//  Created by Boris Emorine on 2/9/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension CGPoint {
    
    func surroundingRect(withDistance distance: CGFloat) -> CGRect {
        return CGRect(x: x - distance / 2.0, y: y - distance / 2.0, width: distance, height: distance)

    }
    
}
