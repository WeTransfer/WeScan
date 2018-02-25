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
        let rectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect1, withCount: funnel.minNumberOfRectangles - 1)
        
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
        let rectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect1, withCount: funnel.minNumberOfRectangles)
        
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
        let rectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect1, withCount: funnel.maxNumberOfRectangles * 2)
        
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
        let rectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect1, withCount: funnel.maxNumberOfRectangles * 2)
        
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
    
    /// Ensures that feeding the funnel with 2 images alternatively (image 1, image 2, image 1, image 2, image 1 etc.), doesn't make the completion block get called every time a new one is added.
    func testAddAlternateImage() {
        let count = 100
        let type1RectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect1, withCount: count)
        let type2RectangleFeatures = ImageFeatureTestHelpers.getRectangleFeatures(from: .rect2, withCount: count)
        var currentlyDisplayedRect: CIRectangleFeature?
        
        let expectation = XCTestExpectation(description: "Funnel add callback")
        expectation.isInverted = true
        
        for i in 0 ..< count {
            let rectangleFeature = i % 2 == 0 ? type1RectangleFeatures[i] : type2RectangleFeatures[i]
            funnel.add(rectangleFeature, currentlyDisplayedRectangle: currentlyDisplayedRect, completion: { (rectFeature) in
                
                currentlyDisplayedRect = rectFeature
                if i >= funnel.maxNumberOfRectangles {
                    expectation.fulfill()
                }
            })
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
}
