//
//  CGRect+Utils.swift
//  Scanner
//
//  Created by Boris Emorine on 2/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension CGRect {
    
    func scaleAndCenter(withRatio ratio: CGFloat) -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: ratio, y: ratio)
        let scaledRect = applying(scaleTransform)
        
        let translateTransform = CGAffineTransform(translationX: (width - scaledRect.width) / 2.0, y: (height - scaledRect.height) / 2.0)
        let translatedRect = scaledRect.applying(translateTransform)
        
        return translatedRect
    }
    
}
