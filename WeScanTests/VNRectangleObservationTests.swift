//
//  VNRectangleObservationTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

class VNRectangleObservationTests: XCTestCase {
    
  func testCorrectlyDetectsAndReturnsQuadilateral() {
    
    let targetSize = CGSize(width: 50, height: 50)
    
    let containerLeyer =  CALayer()
    containerLeyer.backgroundColor = UIColor.black.cgColor
    containerLeyer.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    containerLeyer.masksToBounds = true
    
    let targetLayer = CALayer()
    targetLayer.backgroundColor = UIColor.white.cgColor
    targetLayer.frame = containerLeyer.frame.insetBy(dx: 5, dy: 5)
    
    containerLeyer.addSublayer(targetLayer)
    
    UIGraphicsBeginImageContextWithOptions(targetSize, true, 1.0)
    
    containerLeyer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let ciImage = CIImage(cgImage: image.cgImage!)
    
    VisionRectangleDetector.rectangle(forImage: ciImage) { (quad) in
      
      DispatchQueue.main.async {
        let resultView = UIView(frame: containerLeyer.frame)
        resultView.layer.addSublayer(containerLeyer)
        
        let quadView = QuadrilateralView(frame: resultView.bounds)
        quadView.drawQuadrilateral(quad: quad!, animated: false)
        resultView.addSubview(quadView)
        
        //  We should render this somewhere as a some sort of test.
        print("")
      }
    }
  }
    
}
