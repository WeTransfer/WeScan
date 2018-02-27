//
//  RectangleView.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

/// The `QuadrilateralView` is a simple `UIView` subclass that can draw a quadrilateral, and optionally edit it.
final class QuadrilateralView: UIView {
    
    private let quadLayer = CAShapeLayer()
    
    /// The quadrilateral drawn on the view.
    private(set) var quad: Quadrilateral?
    
    public var editable = false {
        didSet {
            editable == true ? showCornerButtons() : hideCornerButtons()
            guard let quad = quad else {
                return
            }
            drawQuad(quad, animated: false)
            layoutCornerButtons(forQuad: quad)
        }
    }
    
    lazy private var topLeftCornerButton: EditScanCornerView = {
        return cornerButton(atPosition: .topLeft)
    }()
    
    lazy private var topRightCornerButton: EditScanCornerView = {
        return cornerButton(atPosition: .topRight)
    }()
    
    lazy private var bottomRightCornerButton: EditScanCornerView = {
        return cornerButton(atPosition: .bottomRight)
    }()
    
    lazy private var bottomLeftCornerButton: EditScanCornerView = {
        return cornerButton(atPosition: .bottomLeft)
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
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
            drawQuadrilateral(quad: quad, animated: false)
        }
    }
    
    // MARK: - Drawings
    
    /// Draws the passed in quadrilateral.
    ///
    /// - Parameters:
    ///   - quad: The quadrilateral to draw on the view. It should be in the coordinates of the current `QuadrilateralView` instance.
    func drawQuadrilateral(quad: Quadrilateral, animated: Bool) {
        self.quad = quad
        drawQuad(quad, animated: animated)
        if editable {
            showCornerButtons()
            layoutCornerButtons(forQuad: quad)
        }
    }
    
    private func drawQuad(_ quad: Quadrilateral, animated: Bool) {
        var path = quad.path()
        
        if editable {
            path = path.reversing()
            let rectPath = UIBezierPath(rect: bounds)
            path.append(rectPath)
        }
        
        if animated == true {
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.duration = 0.2
            quadLayer.add(pathAnimation, forKey: "path")
        }
        
        quadLayer.path = path.cgPath
        quadLayer.fillColor = editable ? UIColor(white: 0.0, alpha: 0.6).cgColor : UIColor(white: 1.0, alpha: 0.5).cgColor
        quadLayer.strokeColor = UIColor.white.cgColor
        quadLayer.lineWidth = 2.0
        quadLayer.opacity = 1.0
        quadLayer.isHidden = false
    }
    
    private func layoutCornerButtons(forQuad quad: Quadrilateral) {
        let buttonSize: CGFloat = 30.0
        
        topLeftCornerButton.frame = CGRect(x: quad.topLeft.x - buttonSize / 2.0, y: quad.topLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        topLeftCornerButton.layer.cornerRadius = buttonSize / 2.0
        
        topRightCornerButton.frame = CGRect(x: quad.topRight.x - buttonSize / 2.0, y: quad.topRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        topRightCornerButton.layer.cornerRadius = buttonSize / 2.0
        
        bottomRightCornerButton.frame = CGRect(x: quad.bottomRight.x - buttonSize / 2.0, y: quad.bottomRight.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        bottomRightCornerButton.layer.cornerRadius = buttonSize / 2.0
        
        bottomLeftCornerButton.frame = CGRect(x: quad.bottomLeft.x - buttonSize / 2.0, y: quad.bottomLeft.y - buttonSize / 2.0, width: buttonSize, height: buttonSize)
        bottomLeftCornerButton.layer.cornerRadius = buttonSize / 2.0
    }
    
    func removeQuadrilateral() {
        quadLayer.path = nil
        quadLayer.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc func dragCorner(panGesture: UIPanGestureRecognizer) {
        guard let cornerButton = panGesture.view as? EditScanCornerView,
            let quad = quad else {
                return
        }
        
        var center = panGesture.location(in: self)
        center = validPoint(center, forCornerViewOfSize: cornerButton.bounds.size, withQuad: quad, inView: self)
        
        panGesture.view?.center = center
        let updatedQuad = updated(quad, withPosition: center, forCorner: cornerButton.position)
        
        self.quad = updatedQuad
        drawQuad(updatedQuad, animated: false)
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
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
        button.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragCorner(panGesture:)))
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

/// Simple enum to keep track of the position of the corners of a quadrilateral.
fileprivate enum CornerPosition {
    case topLeft
    case topRight
    case bottomRight
    case bottomLeft
}

/// A UIView used by corners of a quadrilateral that is aware of its position.
final fileprivate class EditScanCornerView: UIView {
    
    let position: CornerPosition
    
    init(frame: CGRect, position: CornerPosition) {
        self.position = position
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
