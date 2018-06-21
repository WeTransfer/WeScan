//
//  ScanOperationTests.swift
//  WeScanTests
//
//  Created by Boris Emorine on 6/21/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import WeScan

final class ScanOperationTests: XCTestCase {
    
    /// Ensures that ScanOperations generate a proper ScannedImage
    func testScannedImageGeneration() {
        let image = UIImage(named: "BigRectangle.jpg", in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)!
        let quad = Quadrilateral(topLeft: CGPoint(x: 100.0, y: 100.0), topRight: CGPoint(x: 900.0, y: 100.0), bottomRight: CGPoint(x: 900.0, y: 900.0), bottomLeft: CGPoint(x: 100.0, y: 900.0))
        let result = ImageScannerResults(originalImage: image, detectedRectangle: quad)
        let operation = ScanOperation(withResults: result)
        
        let expectation = XCTestExpectation(description: "Operation completion block called")
        
        operation.completionBlock = {
            XCTAssertTrue(Thread.isMainThread, "The completion block of the operation should be called on the main thread.")
            XCTAssertNotNil(operation.imageScannerResults.scannedImage, "The scannedImage of the result should be generated")
            XCTAssert(operation.isReady == false)
            XCTAssert(operation.isExecuting == false)
            XCTAssert(operation.isFinished == true)
            expectation.fulfill()
        }
        
        XCTAssertNil(operation.imageScannerResults.scannedImage, "The scannedImage of the result is not generated before the operation is added to the queue.")
        XCTAssert(operation.isReady == true)
        XCTAssert(operation.isExecuting == false)
        XCTAssert(operation.isFinished == false)
        
        let operationQueue = OperationQueue()
        operationQueue.addOperation(operation)
        
        wait(for: [expectation], timeout: 5.0)
    }

}
