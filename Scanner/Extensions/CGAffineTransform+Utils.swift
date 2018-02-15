//
//  CGAffineTransform+Utils.swift
//  Scanner
//
//  Created by Boris Emorine on 2/15/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension CGAffineTransform {
    
    static func scaleTransform(forSize fromSize: CGSize, aspectFillInSize toSize: CGSize) -> CGAffineTransform {
        let scale = max(toSize.width / fromSize.width, toSize.height/fromSize.height)
        return CGAffineTransform(scaleX: scale, y: scale)
    }
    
    static func translateTransform(fromCenterOfRect fromRect: CGRect, toCenterOfRect toRect: CGRect) -> CGAffineTransform {
        let translate = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
        return CGAffineTransform(translationX: translate.x, y: translate.y)
    }
        
}
