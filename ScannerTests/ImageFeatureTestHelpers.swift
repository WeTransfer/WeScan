//
//  ImageFeatureTestHelpers.swift
//  ScannerTests
//
//  Created by Boris Emorine on 2/24/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation
@testable import Scanner

final class ImageFeatureTestHelpers: NSObject {
    
    static func getIdenticalRectangleFeatures(withCount count: Int) -> [CIRectangleFeature] {
        var rectangleFeatures = [CIRectangleFeature]()
        for _ in 0 ..< count {
            rectangleFeatures.append(ImageFeatureTestHelpers.getRectangleFeature())
        }
        
        return rectangleFeatures
    }
    
    static func getRectangleFeature() -> CIRectangleFeature {
        let image = UIImage(named: "Square.jpg", in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let ciImage = CIImage(image: image!)!
        let rectangleFeature = RectangleDetector.rectangle(forImage: ciImage)

        return rectangleFeature!
    }
    
}
