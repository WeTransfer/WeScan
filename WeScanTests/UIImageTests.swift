//
//  UIImageTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
@testable import WeScan

final class UIImageTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    func testRotateUpFacingImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let orientatedImage = UIImage(cgImage: image!.cgImage!, scale: 1.0, orientation: .up)
        
        let view = UIImageView(image: orientatedImage.applyingPortraitOrientation())
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testRotateDownFacingImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let orientatedImage = UIImage(cgImage: image!.cgImage!, scale: 1.0, orientation: .down)
        
        let view = UIImageView(image: orientatedImage.applyingPortraitOrientation())
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testRotateLeftFacingImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let orientatedImage = UIImage(cgImage: image!.cgImage!, scale: 1.0, orientation: .left)
        
        let view = UIImageView(image: orientatedImage.applyingPortraitOrientation())
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testRotateRightFacingImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let orientatedImage = UIImage(cgImage: image!.cgImage!, scale: 1.0, orientation: .right)
        
        let view = UIImageView(image: orientatedImage.applyingPortraitOrientation())
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testRotateDefaultFacingImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let orientatedImage = UIImage(cgImage: image!.cgImage!, scale: 1.0, orientation: .rightMirrored)
        
        let view = UIImageView(image: orientatedImage.applyingPortraitOrientation())
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testRotateImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        
        let view = UIImageView(image: image!.rotated(by: Measurement(value: Double.pi * 0.2, unit: .radians), options: []))
        view.sizeToFit()
        
        FBSnapshotVerifyView(view, perPixelTolerance: 6 / 256)
    }
    
    func testScaledImageSuccessfully() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)!
        XCTAssertNotNil(image.scaledImage(scaleFactor: 0.2))
    }
    
    func testScaledImageCorrectly() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)!
        XCTAssertEqual(image.size, CGSize(width: 500, height: 500))
        XCTAssertEqual(image.scaledImage(scaleFactor: 0.2)!.size, CGSize(width: 100, height: 100))
    }
    
    func testPDFDataCreationSuccessful() {
        let image = UIImage(named: ResourceImage.rect2.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)!
        XCTAssertNotNil(image.pdfData())
    }
}
