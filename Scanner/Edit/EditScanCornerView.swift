//
//  EditScanCornerView.swift
//  Scanner
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

enum CornerPosition {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}

final class EditScanCornerView: UIView {
    
    let position: CornerPosition
    
    init(frame: CGRect, position: CornerPosition) {
        self.position = position
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
