//
//  QuadrilateralTests.swift
//  ScannerTests
//
//  Created by Boris Emorine on 2/14/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
@testable import Scanner

class QuadrilateralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSquale() {
        var topLeft = CGPoint(x: 0.0, y: 0.0)
        var topRight = CGPoint(x: 100.0, y: 0.0)
        var bottomRight = CGPoint(x: 100.0, y: 100.0)
        var bottomLeft = CGPoint(x: 0.0, y: 100.0)
        
        var quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        var fromImageSize = CGSize(width: 500.0, height: 500.0)
        var toImageSize = CGSize(width: 1000.0, height: 1000.0)
        
        var scaledQuad = quad.scale(fromImageSize, toImageSize)
        
        XCTAssert(scaledQuad?.topLeft == CGPoint(x: 0.0, y: 0.0))
        XCTAssert(scaledQuad?.topRight == CGPoint(x: 200.0, y: 0.0))
        XCTAssert(scaledQuad?.bottomRight == CGPoint(x: 200.0, y: 200.0))
        XCTAssert(scaledQuad?.bottomLeft == CGPoint(x: 0.0, y: 200.0))
        
        topLeft = CGPoint(x: 50.0, y: 75.0)
        topRight = CGPoint(x: 100.0, y: 25.0)
        bottomRight = CGPoint(x: 75.0, y: 100.0)
        bottomLeft = CGPoint(x: 25.0, y: 200.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        scaledQuad = quad.scale(fromImageSize, toImageSize)
        
        XCTAssert(scaledQuad?.topLeft == CGPoint(x: 100.0, y: 150.0))
        XCTAssert(scaledQuad?.topRight == CGPoint(x: 200.0, y: 50.0))
        XCTAssert(scaledQuad?.bottomRight == CGPoint(x: 150.0, y: 200.0))
        XCTAssert(scaledQuad?.bottomLeft == CGPoint(x: 50.0, y: 400.0))
        
        fromImageSize = CGSize(width: 500.0, height: 500.0)
        toImageSize = CGSize(width: 250.0, height: 250.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize)
        
        XCTAssert(scaledQuad?.topLeft == CGPoint(x: 25.0, y: 37.5))
        XCTAssert(scaledQuad?.topRight == CGPoint(x: 50.0, y: 12.5))
        XCTAssert(scaledQuad?.bottomRight == CGPoint(x: 37.5, y: 50.0))
        XCTAssert(scaledQuad?.bottomLeft == CGPoint(x: 12.5, y: 100.0))
        
        fromImageSize = CGSize(width: 100.0, height: 200.0)
        toImageSize = CGSize(width: 300.0, height: 100.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize)
        XCTAssertNil(scaledQuad)
    }
    
    func testScaleFixRotation() {
        var topLeft = CGPoint(x: 0.0, y: 0.0)
        var topRight = CGPoint(x: 500.0, y: 0.0)
        var bottomRight = CGPoint(x: 500.0, y: 500.0)
        var bottomLeft = CGPoint(x: 0.0, y: 500.0)
        
        var quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        var fromImageSize = CGSize(width: 500.0, height: 500.0)
        var toImageSize = CGSize(width: 500.0, height: 500.0)
        
        var scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 0.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 0.0)))
        
        topLeft = CGPoint(x: 0.0, y: 500.0)
        topRight = CGPoint(x: 1000.0, y: 500.0)
        bottomRight = CGPoint(x: 1000.0, y: 0.0)
        bottomLeft = CGPoint(x: 0.0, y: 0.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        fromImageSize = CGSize(width: 1000.0, height: 500.0)
        toImageSize = CGSize(width: 500.0, height: 1000.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 0.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 1000.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 1000.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 0.0)))
        
        topLeft = CGPoint(x: 0.0, y: 500.0)
        topRight = CGPoint(x: 1000.0, y: 500.0)
        bottomRight = CGPoint(x: 1000.0, y: 0.0)
        bottomLeft = CGPoint(x: 0.0, y: 0.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        fromImageSize = CGSize(width: 1000.0, height: 500.0)
        toImageSize = CGSize(width: 250.0, height: 500.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 0.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 0.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 250.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 250.0, y: 0.0)))
        
        topLeft = CGPoint(x: 250.0, y: 500.0)
        topRight = CGPoint(x: 500.0, y: 500.0)
        bottomRight = CGPoint(x: 500.0, y: 250.0)
        bottomLeft = CGPoint(x: 250.0, y: 250.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        fromImageSize = CGSize(width: 750.0, height: 750.0)
        toImageSize = CGSize(width: 750.0, height: 750.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 250.0, y: 250.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 250.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 250.0)))
        
        topLeft = CGPoint(x: 250.0, y: 500.0)
        topRight = CGPoint(x: 750.0, y: 500.0)
        bottomRight = CGPoint(x: 750.0, y: 250.0)
        bottomLeft = CGPoint(x: 250.0, y: 250.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        fromImageSize = CGSize(width: 1000.0, height: 750.0)
        toImageSize = CGSize(width: 1500.0, height: 2000.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 500.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 500.0, y: 1500.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 1000.0, y: 1500.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 1000.0, y: 500.0)))
        
        topLeft = CGPoint(x: 100.0, y: 400.0)
        topRight = CGPoint(x: 200.0, y: 400.0)
        bottomRight = CGPoint(x: 200.0, y: 300.0)
        bottomLeft = CGPoint(x: 100.0, y: 300.0)
        
        quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        fromImageSize = CGSize(width: 1000.0, height: 500.0)
        toImageSize = CGSize(width: 1000.0, height: 2000.0)
        
        scaledQuad = quad.scale(fromImageSize, toImageSize, fixRotation: true)
        
        XCTAssertTrue(scaledQuad!.topLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 200.0, y: 200.0)))
        XCTAssertTrue(scaledQuad!.topRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 200.0, y: 400.0)))
        XCTAssertTrue(scaledQuad!.bottomRight.isWithin(delta: 0.01, ofPoint: CGPoint(x: 400.0, y: 400.0)))
        XCTAssertTrue(scaledQuad!.bottomLeft.isWithin(delta: 0.01, ofPoint: CGPoint(x: 400.0, y: 200.0)))
    }
    
}
