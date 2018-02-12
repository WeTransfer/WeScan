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
        
        let deskewedQuad = quad.deskew(withImageSize: imageSize, inViewSize: bounds.size)
        
        let path = deskewedQuad.path()
        quadLayer.path = path.cgPath
        quadLayer.fillColor = UIColor.blue.cgColor
        quadLayer.opacity = 0.3
        quadLayer.isHidden = false
    }
    
    func removeQuadrilateral() {
        quadLayer.isHidden = true
    }

  
}
