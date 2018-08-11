//
//  CIRectangleDetectorTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

class CIRectangleDetectorTests: XCTestCase {
    
    func testDetectorUsesValidType() {
        XCTAssertNotNil(CIRectangleDetector.rectangleDetector)
    }
}
