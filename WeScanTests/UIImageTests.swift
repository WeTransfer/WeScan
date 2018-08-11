//
//  UIImageTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

class UIImageTests: XCTestCase {
        
    func testScailingNonCGBackedUIImageReturnNil() {
        let image = UIImage()
        XCTAssertNil(image.scaledImage(atPoint: .zero, scaleFactor: 0.0, targetSize: .zero))
    }
  
    func testScailingToInvalidSizeUIImageReturnNil() {
      
      let size = CGSize(width: 1, height: 1)
      
      UIGraphicsBeginImageContextWithOptions(size, false, 1)
      let image = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      
      XCTAssertNil(image.scaledImage(atPoint: .zero, scaleFactor: 5.0, targetSize: .zero))
    }
  
  func testScalesCorrectly() {
    
    let middle = CGPoint(x: 0.5, y: 0.5)
    let size = CGSize(width: 1, height: 1)
    let targetSize = CGSize(width: 2.0, height: 2.0)

    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let scaledImage = image.scaledImage(atPoint: middle, scaleFactor: 2.0, targetSize: targetSize)!

    XCTAssertEqual(scaledImage.size.width, 1.0)
    XCTAssertEqual(scaledImage.size.height, 1.0)
  }
}
