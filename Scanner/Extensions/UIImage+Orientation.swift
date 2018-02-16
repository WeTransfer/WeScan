//
//  UIImage+Orientation.swift
//  Scanner
//
//  Created by Boris Emorine on 2/16/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

extension UIImage {
    
    func imageWithPortraitOrientation() -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
}
