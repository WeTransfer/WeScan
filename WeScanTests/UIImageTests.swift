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
    
//    let size = CGSize(width: 1, height: 1)
//    
//    UIGraphicsBeginImageContextWithOptions(size, false, 1)
//    let image = UIGraphicsGetImageFromCurrentImageContext()!
//    UIGraphicsEndImageContext()
//    
//    XCTAssertNil(image.scaledImage(atPoint: .zero, scaleFactor: 5.0, targetSize: .zero))
  }
}
