//
//  CGSize+Utils.swift
//  WeScan
//
//  Created by Julian Schiavo on 17/2/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

extension CGSize {
    func scaleFactor(forMaxWidth maxWidth: CGFloat) -> CGFloat {
        if width < maxWidth { return 1 }
        
        return self.width / maxWidth
    }
}
