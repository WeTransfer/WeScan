//
//  CGAffineTransformTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

class CGAffineTransformTests: XCTestCase {
//    
//  /// Convenience function to easily get a scale `CGAffineTransform` instance.
//  ///
//  /// - Parameters:
//  ///   - fromSize: The size that needs to be transformed to fit (aspect fill) in the other given size.
//  ///   - toSize: The size that should be matched by the `fromSize` parameter.
//  /// - Returns: The transform that will make the `fromSize` parameter fir (aspect fill) inside the `toSize` parameter.
//  static func scaleTransform(forSize fromSize: CGSize, aspectFillInSize toSize: CGSize) -> CGAffineTransform {
//    let scale = max(toSize.width / fromSize.width, toSize.height / fromSize.height)
//    return CGAffineTransform(scaleX: scale, y: scale)
//  }
  
  
  func testScalesUpCorrectly() {
    
    let fromSize = CGSize(width: 1, height: 1)
    let toSize =  CGSize(width: 2, height: 2)
    
    let scale = CGAffineTransform.scaleTransform(forSize: fromSize, aspectFillInSize: toSize)

    XCTAssertEqual(scale.a, 2)
    XCTAssertEqual(scale.d, 2)
  }
  
  func testScalesDownCorrectly() {
    
    let fromSize = CGSize(width: 2, height: 2)
    let toSize =  CGSize(width: 1, height: 1)
    
    let scale = CGAffineTransform.scaleTransform(forSize: fromSize, aspectFillInSize: toSize)
    
    XCTAssertEqual(scale.a, 0.5)
    XCTAssertEqual(scale.d, 0.5)
  }
  
//  
//  /// Convenience function to easily get a translate `CGAffineTransform` instance.
//  ///
//  /// - Parameters:
//  ///   - fromRect: The rect which center needs to be translated to the center of the other passed in rect.
//  ///   - toRect: The rect that should be matched.
//  /// - Returns: The transform that will translate the center of the `fromRect` parameter to the center of the `toRect` parameter.
//  static func translateTransform(fromCenterOfRect fromRect: CGRect, toCenterOfRect toRect: CGRect) -> CGAffineTransform {
//    let translate = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
//    return CGAffineTransform(translationX: translate.x, y: translate.y)
//  }
  
  
  func testTranslatesCorrectly() {
    
    let fromRect = 0
    let toRect = 0
    
  }
    
}
