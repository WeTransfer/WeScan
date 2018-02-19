//
//  CGPointTests.swift
//  ScannerTests
//
//  Created by Boris Emorine on 2/19/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import Scanner

class CGPointTests: XCTestCase {
    
    func testSurroundingRect() {
        var point = CGPoint.zero
        var rect = point.surroundingSquare(withSize: 10.0)
        var expectedRect = CGRect(x: -5.0, y: -5.0, width: 10.0, height: 10.0)
        XCTAssert(rect == expectedRect)
        
        point = CGPoint(x: 50.0, y: 50.0)
        rect = point.surroundingSquare(withSize: 20.0)
        expectedRect = CGRect(x: 40.0, y: 40.0, width: 20.0, height: 20.0)
        XCTAssert(rect == expectedRect)
    }
    
}
