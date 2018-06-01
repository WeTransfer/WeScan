//
//  ZoomQuadrilateralViewController.swift
//  WeScan
//
//  Created by Bobo on 5/31/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

final class ZoomPanController {
    
    private let image: UIImage
    private let quadView: QuadrilateralView
    
    init(image: UIImage, quadView: QuadrilateralView) {
        self.image = image
        self.quadView = quadView
    }
    
    private var previousPanPosition: CGPoint?
    private var closestCorner: CornerPosition?
    
    @objc func handle(pan: UIPanGestureRecognizer) {
        guard let drawnQuad = quadView.quad else {
            return
        }
        
        guard pan.state != .ended else {
            previousPanPosition = nil
            closestCorner = nil
            return
        }
        
        var position = pan.location(in: quadView)
        
        guard let previousPanPosition = previousPanPosition,
            let closestCorner = closestCorner else {
                self.previousPanPosition = position
                self.closestCorner = position.closestCornerFrom(quad: drawnQuad)
                return
        }
        
        let offset = CGAffineTransform(translationX: position.x - previousPanPosition.x, y: position.y - previousPanPosition.y)
        quadView.dragCorner(corner: closestCorner, withOffset: offset)
        self.previousPanPosition = position

        position = CGPoint(x: position.x - quadView.frame.origin.x, y: position.y - quadView.frame.origin.y)
        let scale = image.size.width / quadView.frame.size.width
        let scaledPosition = CGPoint(x: position.x * scale, y: position.y * scale)
        
        let zoomedImage = image.scaledImage(atPoint: scaledPosition, scaleFactor: 2.5, targetSize: quadView.frame.size)
    }

}
