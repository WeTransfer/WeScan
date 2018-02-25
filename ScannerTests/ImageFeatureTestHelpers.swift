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

enum ResourceImage: String {
    case rect1 = "Square.jpg"
    case rect2 = "Rectangle.jpg"
}

final class ImageFeatureTestHelpers: NSObject {
    
    static func getRectangleFeatures(from resourceImage: ResourceImage, withCount count: Int) -> [CIRectangleFeature] {
        var rectangleFeatures = [CIRectangleFeature]()
        for _ in 0 ..< count {
            rectangleFeatures.append(ImageFeatureTestHelpers.getRectangleFeature(from: resourceImage))
        }
        
        return rectangleFeatures
    }
    
    static func getRectangleFeature(from resourceImage: ResourceImage) -> CIRectangleFeature {
        let image = UIImage(named: resourceImage.rawValue, in: Bundle(for: ImageFeatureTestHelpers.self), compatibleWith: nil)
        let ciImage = CIImage(image: image!)!
        let rectangleFeature = RectangleDetector.rectangle(forImage: ciImage)

        return rectangleFeature!
    }
    
}
