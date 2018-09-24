//
//  VisionRectangleDetectorTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
@testable import WeScan


class VisionRectangleDetectorTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    
    recordMode = false
  }
  
  func testCorrectlyDetectsAndReturnsQuadilateral() {

    let targetSize = CGSize(width: 50, height: 50)

    let containerLeyer =  CALayer()
    containerLeyer.backgroundColor = UIColor.white.cgColor
    containerLeyer.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    containerLeyer.masksToBounds = true

    let targetLayer = CALayer()
    targetLayer.backgroundColor = UIColor.black.cgColor
    targetLayer.frame = containerLeyer.frame.insetBy(dx: 5, dy: 5)

    containerLeyer.addSublayer(targetLayer)

    UIGraphicsBeginImageContextWithOptions(targetSize, true, 1.0)

    containerLeyer.render(in: UIGraphicsGetCurrentContext()!)

    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    let ciImage = CIImage(cgImage: image.cgImage!)
    let expectation = XCTestExpectation(description: "Detect rectangle")
    let quad = VisionRectangleDetector.rectangle(forImage: ciImage) { (quad) in
      
      DispatchQueue.main.async {
        
        let resultView = UIView(frame: containerLeyer.frame)
        resultView.layer.addSublayer(containerLeyer)
        
        let quadView = QuadrilateralView(frame: resultView.bounds)
        quadView.drawQuadrilateral(quad: quad!, animated: false)
        quadView.backgroundColor = UIColor.red
        resultView.addSubview(quadView)
        
        self.FBSnapshotVerifyView(resultView)
        expectation.fulfill()
      }
    }
    
    wait(for: [expectation], timeout: 3.0)
  }
}