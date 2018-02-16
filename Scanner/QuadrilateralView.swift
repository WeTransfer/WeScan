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
    private(set) var quad: Quadrilateral?
    
    public var editable = false {
        didSet {
            editable == true ? showCornerButtons() : hideCornerButtons()
            guard let quad = quad else {
                return
            }
            layoutCornerButtons(forQuad: quad)
        }
    }
    
    private lazy var topLeftCornerButton: EditScanCornerView = {
        let cornerButton = self.cornerButton(atPosition: .topLeft)
        return cornerButton
    }()
    
    private lazy var topRightCornerButton: EditScanCornerView = {
        let cornerButton = self.cornerButton(atPosition: .topRight)
        return cornerButton
    }()
    
    private lazy var bottomRightCornerButton: EditScanCornerView = {
        let cornerButton = self.cornerButton(atPosition: .bottomRight)
        return cornerButton
    }()
    private lazy var bottomLeftCornerButton: EditScanCornerView = {
        let cornerButton = self.cornerButton(atPosition: .bottomLeft)
        return cornerButton
    }()
    
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
        setupCornerButtons()
    }
    
    private func setupCornerButtons() {
        addSubview(topLeftCornerButton)
        addSubview(topRightCornerButton)
        addSubview(bottomRightCornerButton)
        addSubview(bottomLeftCornerButton)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        quadLayer.frame = bounds
        if let quad = quad {
            layoutCornerButtons(forQuad: quad)
        }
    }
    
    // MARK: - Drawings
    
    public func drawQuadrilateral(quad: Quadrilateral) {
        self.quad = quad
        drawQuad(quad)
        if editable {
            showCornerButtons()
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
        
        topLeftCornerButton.frame = CGRect(x: quad.topLeft.x - buttonSize / 2.0, y: quad.topLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        topRightCornerButton.frame = CGRect(x: quad.topRight.x - buttonSize / 2.0, y: quad.topRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        bottomRightCornerButton.frame = CGRect(x: quad.bottomRight.x - buttonSize / 2.0, y: quad.bottomRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        bottomLeftCornerButton.frame = CGRect(x: quad.bottomLeft.x - buttonSize / 2.0, y: quad.bottomLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
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
        button.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
        button.addGestureRecognizer(panGesture)
        
        return button
    }
    
    private func hideCornerButtons() {
        topLeftCornerButton.isHidden = true
        topRightCornerButton.isHidden = true
        bottomRightCornerButton.isHidden = true
        bottomLeftCornerButton.isHidden = true
    }
    
    private func showCornerButtons() {
        topLeftCornerButton.isHidden = false
        topRightCornerButton.isHidden = false
        bottomRightCornerButton.isHidden = false
        bottomLeftCornerButton.isHidden = false
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
