//
//  VisionRectangleDetectorTests.swift
//  WeScanTests
//
//  Created by James Campbell on 8/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
@testable import WeScan

final class VisionRectangleDetectorTests: FBSnapshotTestCase {
  
  override func setUp() {
    super.setUp()
    recordMode = false
  }

  /// Function gathered from [here](https://stackoverflow.com/questions/44462087/how-to-convert-a-uiimage-to-a-cvpixelbuffer) to convert UIImage to CVPixelBuffer
  ///
  /// - Parameter image: image to be converted
  /// - Returns: new CVPixelBuffer
  private func buffer(from image: UIImage) -> CVPixelBuffer? {
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
      return nil
    }

    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

    context?.translateBy(x: 0, y: image.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context!)
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

    return pixelBuffer
  }

  
  func testCorrectlyDetectsAndReturnsQuadilateral() {

    let targetSize = CGSize(width: 150, height: 150)

    let containerLayer = CALayer()
    containerLayer.backgroundColor = UIColor.white.cgColor
    containerLayer.frame = CGRect(origin: .zero, size: targetSize)
    containerLayer.masksToBounds = true

    let targetLayer = CALayer()
    targetLayer.backgroundColor = UIColor.black.cgColor
    targetLayer.frame = containerLayer.frame.insetBy(dx: 5, dy: 5)

    containerLayer.addSublayer(targetLayer)

    UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)

    containerLayer.render(in: UIGraphicsGetCurrentContext()!)

    let image = UIGraphicsGetImageFromCurrentImageContext()!

    UIGraphicsEndImageContext()

    let ciImage = CIImage(cgImage: image.cgImage!)
    let expectation = XCTestExpectation(description: "Detect rectangle on CIImage")

    VisionRectangleDetector.rectangle(forImage: ciImage) { (quad) in

      DispatchQueue.main.async {

        let resultView = UIView(frame: containerLayer.frame)
        resultView.layer.addSublayer(containerLayer)

        let quadView = QuadrilateralView(frame: resultView.bounds)
        quadView.drawQuadrilateral(quad: quad!, animated: false)
        quadView.backgroundColor = UIColor.red
        resultView.addSubview(quadView)

        self.FBSnapshotVerifyView(resultView)
        expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 3.0)
  }

  func testCorrectlyDetectsAndReturnsQuadilateralPixelBuffer() {

    let targetSize = CGSize(width: 150, height: 150)

    let containerLayer = CALayer()
    containerLayer.backgroundColor = UIColor.white.cgColor
    containerLayer.frame = CGRect(origin: .zero, size: targetSize)
    containerLayer.masksToBounds = true

    let targetLayer = CALayer()
    targetLayer.backgroundColor = UIColor.black.cgColor
    targetLayer.frame = containerLayer.frame.insetBy(dx: 5, dy: 5)

    containerLayer.addSublayer(targetLayer)

    UIGraphicsBeginImageContextWithOptions(targetSize, true, 0.0)

    containerLayer.render(in: UIGraphicsGetCurrentContext()!)

    let image = UIGraphicsGetImageFromCurrentImageContext()!

    UIGraphicsEndImageContext()

    let expectation = XCTestExpectation(description: "Detect rectangle on CVPixelBuffer")
    if let pixelBuffer = self.buffer(from: image) {
      VisionRectangleDetector.rectangle(forPixelBuffer: pixelBuffer) { (quad) in

        DispatchQueue.main.async {

          let resultView = UIView(frame: containerLayer.frame)
          resultView.layer.addSublayer(containerLayer)

          let quadView = QuadrilateralView(frame: resultView.bounds)
          quadView.drawQuadrilateral(quad: quad!, animated: false)
          quadView.backgroundColor = UIColor.red
          resultView.addSubview(quadView)

          self.FBSnapshotVerifyView(resultView)
          expectation.fulfill()
        }
      }
    } else {
      XCTFail("could not convert image to pixelBuffer")
    }

    wait(for: [expectation], timeout: 3.0)
  }
}
