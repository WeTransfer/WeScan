//
//  Extendable.swift
//  Scanner
//
//  Created by Boris Emorine on 2/15/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

protocol Transformable {
    
    func applying(_ t: CGAffineTransform) -> Self

}

extension Transformable {
    
    func applyTransforms(_ transforms: [CGAffineTransform]) -> Self {
        
        var transformableObject = self
        
        transforms.forEach { (transform) in
            transformableObject = transformableObject.applying(transform)
        }
        
        return transformableObject
    }
    
}
