//
//  RectangleView.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

internal final class QuadrilateralView: UIView {
    
    private let quadLayer = CAShapeLayer()
    private var quad: Quadrilateral?
    
    public var editable = false
    
    // MARK: - Life Cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        layer.addSublayer(quadLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        quadLayer.frame = bounds
    }
    
    // MARK: - Drawings
    
    public func drawQuadrilateral(quad: Quadrilateral) {
        self.quad = quad
        drawQuad(quad)
        
        if editable {
            layoutCornerButtons(forQuad: quad)
        }
    }
    
    private func drawQuad(_ quad: Quadrilateral) {
        let path = quad.path()
        quadLayer.path = path.cgPath
        quadLayer.fillColor = UIColor.blue.cgColor
        quadLayer.strokeColor = UIColor.white.cgColor
        quadLayer.lineWidth = 2.0
        quadLayer.opacity = 0.5
        quadLayer.isHidden = false
    }
    
    private func layoutCornerButtons(forQuad quad: Quadrilateral) {
        let buttonSize = min(min(bounds.size.width, bounds.size.height) / 10.0, 44.0)
        
        let topLeftButton = cornerButton(atPosition: .topLeft)
        topLeftButton.frame = CGRect(x: quad.topLeft.x - buttonSize / 2.0, y: quad.topLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        addSubview(topLeftButton)
        
        let topRightButton = cornerButton(atPosition: .topRight)
        topRightButton.frame = CGRect(x: quad.topRight.x - buttonSize / 2.0, y: quad.topRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        addSubview(topRightButton)
        
        let bottomRightButton = cornerButton(atPosition: .bottomRight)
        bottomRightButton.frame = CGRect(x: quad.bottomRight.x - buttonSize / 2.0, y: quad.bottomRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        addSubview(bottomRightButton)
        
        let bottomLeftButton = cornerButton(atPosition: .bottomLeft)
        bottomLeftButton.frame = CGRect(x: quad.bottomLeft.x - buttonSize / 2.0, y: quad.bottomLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        addSubview(bottomLeftButton)
    }
    
    func removeQuadrilateral() {
        quadLayer.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let cornerButton = panGesture.view as? EditScanCornerView,
            let quad = quad else {
                return
        }
        
        var center = panGesture.location(in: self)
        center = validPoint(center, forCornerViewOfSize: cornerButton.bounds.size, withQuad: quad, inView: self)
        
        panGesture.view?.center = center
        let updatedQuad = updated(quad, withPosition: center, forCorner: cornerButton.position)
        
        self.quad = updatedQuad
        drawQuad(updatedQuad)
    }
    
    // MARK: Validation
    
    private func validPoint(_ point: CGPoint, forCornerViewOfSize cornerViewSize: CGSize, withQuad quad: Quadrilateral, inView view: UIView) -> CGPoint {
        var validPoint = point
        
        if point.x > view.bounds.width {
            validPoint.x = view.bounds.width
        } else if point.x < 0.0 {
            validPoint.x = 0.0
        }
        
        if point.y > view.bounds.height {
            validPoint.y = view.bounds.height
        } else if point.y < 0.0 {
            validPoint.y = 0.0
        }
        
        return validPoint
    }
    
    // MARK - Convenience
    
    private func cornerButton(atPosition position: CornerPosition) -> EditScanCornerView {
        let button = EditScanCornerView(frame: CGRect.zero, position: position)
        button.backgroundColor = UIColor.blue
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        button.addGestureRecognizer(panGesture)
        
        return button
    }
    
    private func updated(_ quad: Quadrilateral, withPosition position: CGPoint, forCorner corner: CornerPosition) -> Quadrilateral {
        var quad = quad
        
        switch corner {
        case .topLeft:
            quad.topLeft = position
            break
            
        case .topRight:
            quad.topRight = position
            break
            
        case .bottomRight:
            quad.bottomRight = position
            break
            
        case .bottomLeft:
            quad.bottomLeft = position
            break
        }
        
        return quad
    }
}
