//
//  Quadrilateral.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

struct Quadrilateral {
    
    var topLeft: CGPoint
    
    var topRight: CGPoint
    
    var bottomRight: CGPoint
    
    var bottomLeft: CGPoint
    
    init(rectagleFeature: CIRectangleFeature) {
        self.topLeft = rectagleFeature.topLeft
        self.topRight = rectagleFeature.topRight
        self.bottomLeft = rectagleFeature.bottomLeft
        self.bottomRight = rectagleFeature.bottomRight
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
    
    func deskew(withImageSize imageSize: CGSize, inViewSize viewSize: CGSize) -> Quadrilateral {
        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
        
        let scaleTransform = transform(forSize: portraitImageSize, aspectFillIntoSize: viewSize)
        let scaledQuad = applying(scaleTransform)
        
        let scaledImageSize = imageSize.applying(scaleTransform)
        
        let flipTransform = flipCoordinate(withHeight: scaledImageSize.height)
        let flippedQuad = scaledQuad.applying(flipTransform)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        let rotatedQuad = flippedQuad.applying(rotationTransform)
        
        let imageBounds = CGRect(x: 0.0, y: 0.0, width: scaledImageSize.width, height: scaledImageSize.height).applying(rotationTransform)
        
        let translateTransform = translate(fromCenterOfRect: imageBounds, toCenterOfRect: CGRect(x: 0.0, y: 0.0, width: viewSize.width, height: viewSize.height))
        let translatedQuad = rotatedQuad.applying(translateTransform)
        
        return translatedQuad
    }
    
    // MARK: Convenience Functions
    
    private func transform(forSize fromSize: CGSize, aspectFillIntoSize toSize: CGSize) -> CGAffineTransform {
        let scale = max(toSize.width / fromSize.width, toSize.height/fromSize.height)
        return CGAffineTransform(scaleX: scale, y: scale)
    }
    
    private func flipCoordinate(withHeight height: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -height)
        return transform
    }
    
    private func translate(fromCenterOfRect fromRect: CGRect, toCenterOfRect toRect: CGRect) -> CGAffineTransform {
        let translate = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
        return CGAffineTransform(translationX: translate.x, y: translate.y)
    }
    
}
