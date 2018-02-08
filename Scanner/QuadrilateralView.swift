//
//  RectangleView.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

final class QuadrilateralView: UIView {
    
    private let quadLayer = CAShapeLayer()

    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        layer.addSublayer(quadLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        quadLayer.frame = bounds
    }
    
    // MARK: - Drawings

    func drawQuadrilateral(quad: Quadrilateral, imageSize: CGSize) {
        
        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
        
        let scaleTransform = transform(forSize: portraitImageSize, aspectFillIntoSize: bounds.size)
        let scaledQuad = quad.applying(scaleTransform)
        
        let scaledImageSize = imageSize.applying(scaleTransform)
        
        let flipTransform = flipCooridnateSystem(withHeight: scaledImageSize.height)
        let flippedQuad = scaledQuad.applying(flipTransform)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        let rotatedQuad = flippedQuad.applying(rotationTransform)
        
        let imageBounds = CGRect(x: 0.0, y: 0.0, width: scaledImageSize.width, height: scaledImageSize.height).applying(rotationTransform)
        
        let translateTransform = translate(fromCenterOfRect: imageBounds, toCenterOfRect: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: bounds.size.height))
        let translatedQuad = rotatedQuad.applying(translateTransform)
        
        let path = translatedQuad.path()
        quadLayer.path = path.cgPath
        quadLayer.fillColor = UIColor.blue.cgColor
        quadLayer.opacity = 0.3
        quadLayer.isHidden = false
    }
    
    func removeQuadrilateral() {
        quadLayer.isHidden = true
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
