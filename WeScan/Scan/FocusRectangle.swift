//
//  FocusRectangle.swift
//  WeScan
//
//  Created by Julian Schiavo on 16/11/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

final class FocusRectangle: UIView {
    convenience init(touchPoint: CGPoint) {
        let originalSize: CGFloat = 200
        let finalSize: CGFloat = 80
        
        self.init(frame: CGRect(x: touchPoint.x - (originalSize / 2), y: touchPoint.y - (originalSize / 2), width: originalSize, height: originalSize))
        
        backgroundColor = .clear
        layer.borderWidth = 2.0
        layer.cornerRadius = 6.0
        layer.borderColor = UIColor.yellow.cgColor
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.x += (originalSize - finalSize) / 2
            self.frame.origin.y += (originalSize - finalSize) / 2
            
            self.frame.size.width -= (originalSize - finalSize)
            self.frame.size.height -= (originalSize - finalSize)
        })
    }
    
}
