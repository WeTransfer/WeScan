//
//  CGSize+Utils.swift
//  WeScan
//
//  Created by Julian Schiavo on 17/2/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

extension CGSize {
    func scaleFactor(forMaxWidth maxWidth: CGFloat, maxHeight: CGFloat) -> CGFloat {
        if width < maxWidth && height < maxHeight { return 1 }
        
        let widthScaleFactor = 1 / (self.width / maxWidth)
        let heightScaleFactor = 1 / (self.height / maxHeight)
        
        print(widthScaleFactor, self.width * widthScaleFactor)
        print(heightScaleFactor, self.height * heightScaleFactor)
        
        // Use the smaller scale factor to ensure both the width and height are below the max
        return min(widthScaleFactor, heightScaleFactor)
    }
}