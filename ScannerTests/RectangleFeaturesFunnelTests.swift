//
//  RectangleFeaturesFunnelTests.swift
//  ScannerTests
//
//  Created by Boris Emorine on 2/24/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import Scanner

final class RectangleFeaturesFunnelTests: XCTestCase {
    
    var funnel = RectangleFeaturesFunnel()
    
    override func setUp() {
        funnel = RectangleFeaturesFunnel()
    }
    
    /// Ensures that feeding the funnel with less than the minimum number of rectangles doesn't trigger the completion block.
    func testAddMinUnderThreshold() {
        let rectangleFeatures = ImageFeatureTestHelpers.getIdenticalRectangleFeatures(withCount: funnel.minNumberOfRectangles - 1)
        
        let expectation = XCTestExpectation(description: "Funnel add callback")
        expectation.isInverted = true
        
        for i in 0 ..< rectangleFeatures.count {
            funnel.add(rectangleFeatures[i], currentlyDisplayedRectangle: nil) { (rectFeature) in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// Ensures that feeding the funnel with the minimum number of rectangles triggers the completion block.
    func testAddMinThreshold() {
        let rectangleFeatures = ImageFeatureTestHelpers.getIdenticalRectangleFeatures(withCount: funnel.minNumberOfRectangles)
        
        let expectation = XCTestExpectation(description: "Funnel add callback")
        
        for i in 0 ..< rectangleFeatures.count {
            funnel.add(rectangleFeatures[i], currentlyDisplayedRectangle: nil) { (rectFeature) in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// Ensures that feeding the funnel with a lot of rectangles triggers the completion block the appropriate amount of time.
    func testAddMaxThreshold() {
        let rectangleFeatures = ImageFeatureTestHelpers.getIdenticalRectangleFeatures(withCount: funnel.maxNumberOfRectangles * 2)
        
        let expectation = XCTestExpectation(description: "Funnel add callback")
        expectation.expectedFulfillmentCount = rectangleFeatures.count - funnel.minNumberOfRectangles
        
        for i in 0 ..< rectangleFeatures.count {
            funnel.add(rectangleFeatures[i], currentlyDisplayedRectangle: nil) { (rectFeature) in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    /// Ensures that feeding the funnel with rectangles similar than the currently displayed one doesn't trigger the completion block.
    func testAddPreviouslyDisplayedRect() {
        let rectangleFeatures = ImageFeatureTestHelpers.getIdenticalRectangleFeatures(withCount: funnel.maxNumberOfRectangles * 2)
        
        let expectation = XCTestExpectation(description: "Funnel add callback")
        expectation.isInverted = true
        
        let currentlyDisplayedRect = rectangleFeatures.first!
        
        for i in 0 ..< rectangleFeatures.count {
            funnel.add(rectangleFeatures[i], currentlyDisplayedRectangle: currentlyDisplayedRect) { (rectFeature) in
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
}
