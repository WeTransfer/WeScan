//
//  CaptureSessionTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

class CaptureSessionTests: XCTestCase {
    
    func testAutoScanEnabledByDefault() {
        let session = CaptureSession.current
        XCTAssertTrue(session.autoScanEnabled)
    }
  
    func testEditOrientationDownMirroedByDefault() {
        let session = CaptureSession.current
        XCTAssertEqual(session.editImageOrientation, CGImagePropertyOrientation.downMirrored)
    }
    
}
