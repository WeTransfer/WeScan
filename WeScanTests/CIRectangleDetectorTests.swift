//
//  CIRectangleDetectorTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
@testable import WeScan

final class CIRectangleDetectorTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
        fileNameOptions = .OS
    }
    
    func testCorrectlyDetectsAndReturnsQuadilateral() {
        
        let targetSize = CGSize(width: 150, height: 150)
        
        let containerLayer = CALayer()
        containerLayer.backgroundColor = UIColor.white.cgColor
        containerLayer.frame = CGRect(origin: .zero, size: targetSize)
        containerLayer.masksToBounds = true
        
        let targetLayer = CALayer()
        targetLayer.backgroundColor = UIColor.black.cgColor
        targetLayer.frame = containerLayer.frame.insetBy(dx: 5, dy: 5)
        
        containerLayer.addSublayer(targetLayer)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)
        
        containerLayer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let ciImage = CIImage(cgImage: image.cgImage!)
        let quad = CIRectangleDetector.rectangle(forImage: ciImage)!
        
        let resultView = UIView(frame: containerLayer.frame)
        resultView.layer.addSublayer(containerLayer)
        
        let quadView = QuadrilateralView(frame: resultView.bounds)
        quadView.drawQuadrilateral(quad: quad, animated: false)
        quadView.backgroundColor = UIColor.red
        resultView.addSubview(quadView)
        
        FBSnapshotVerifyView(resultView, perPixelTolerance: 6 / 256)
    }
    
}
