//
//  CGRect+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/26/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension CGRect {
    
    /// Returns a new `CGRect` instance scaled up or down, with the same center as the original `CGRect` instance.
    /// - Parameters:
    ///   - ratio: The ratio to scale the `CGRect` instance by.
    /// - Returns: A new instance of `CGRect` scaled by the given ratio and centered with the original rect.
    func scaleAndCenter(withRatio ratio: CGFloat) -> CGRect {
        let scaleTransform = CGAffineTransform(scaleX: ratio, y: ratio)
        let scaledRect = applying(scaleTransform)
        
        let translateTransform = CGAffineTransform(translationX: origin.x * (1 - ratio) + (width - scaledRect.width) / 2.0, y: origin.y * (1 - ratio) + (height - scaledRect.height) / 2.0)
        let translatedRect = scaledRect.applying(translateTransform)
        
        return translatedRect
    }
    
    /// Returns a new `CGRect` instance with the same center, with its width and height offset by the passed in value.
    ///
    /// - Parameters:
    ///   - offset: The number of points the rect should be shrinked or expanded by
    /// - Returns: A new instanec of `CGRect` shrinked or expanded by the number of points passed in.
    func expandRect(byOffset offset: CGFloat) -> CGRect {
        return CGRect(x: origin.x - offset / 2.0, y: origin.y - offset / 2.0, width: width + offset, height: height + offset)
    }
    
}
