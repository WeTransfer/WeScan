//
//  Quadrilateral.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

struct Quadrilateral: Transformable {
    
    var topLeft: CGPoint
    
    var topRight: CGPoint
    
    var bottomRight: CGPoint
    
    var bottomLeft: CGPoint
        
    init(rectangleFeature: CIRectangleFeature) {
        self.topLeft = rectangleFeature.topLeft
        self.topRight = rectangleFeature.topRight
        self.bottomLeft = rectangleFeature.bottomLeft
        self.bottomRight = rectangleFeature.bottomRight
    }
    
    init(topLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint, bottomLeft: CGPoint) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    func path() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        return path
    }
    
    func applying(_ t: CGAffineTransform) -> Quadrilateral {
        let quadrilateral = Quadrilateral(topLeft: topLeft.applying(t), topRight: topRight.applying(t), bottomRight: bottomRight.applying(t), bottomLeft: bottomLeft.applying(t))
        
        return quadrilateral
    }
    
    func toCartesian(withHeight height: CGFloat) -> Quadrilateral {
        let topLeft = cartesianForPoint(point: self.topLeft, height: height)
        let topRight = cartesianForPoint(point: self.topRight, height: height)
        let bottomRight = cartesianForPoint(point: self.bottomRight, height: height)
        let bottomLeft = cartesianForPoint(point: self.bottomLeft, height: height)
        
        return Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
    }
    
    func scale(_ fromImageSize: CGSize, _ toImageSize: CGSize, withRotationAngle rotationAngle: CGFloat = 0.0) -> Quadrilateral? {
        var invertedFromImageSize = fromImageSize
        
        if rotationAngle == 0.0 {
            guard fromImageSize.width / toImageSize.width == fromImageSize.height / toImageSize.height else {
                return nil
            }
        } else {
            guard fromImageSize.height / toImageSize.width == fromImageSize.width / toImageSize.height else {
                return nil
            }
            invertedFromImageSize = CGSize(width: fromImageSize.height, height: fromImageSize.width)
        }
        
        var transformedQuad = self
        
        let scale = toImageSize.width / invertedFromImageSize.width
        let scaledTransform = CGAffineTransform(scaleX: scale, y: scale)
        transformedQuad = transformedQuad.applying(scaledTransform)
        
        if rotationAngle != 0.0 {
            let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
            
            let fromImageBounds = CGRect(x: 0.0, y: 0.0, width: fromImageSize.width, height: fromImageSize.height).applying(scaledTransform).applying(rotationTransform)
            
            let toImageBounds = CGRect(x: 0.0, y: 0.0, width: toImageSize.width, height: toImageSize.height)
            let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: fromImageBounds, toCenterOfRect: toImageBounds)
            
            transformedQuad = transformedQuad.applyTransforms([rotationTransform, translationTransform])
        }
        
        return transformedQuad
    }
        // MARK: Convenience Functions
        
    private func cartesianForPoint(point:CGPoint, height: CGFloat) -> CGPoint {
        return CGPoint(x: point.x, y: height - point.y)
    }
    
}
