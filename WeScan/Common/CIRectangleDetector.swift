//
//  RectangleDetector.swift
//  WeScan
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

/// Class used to detect rectangles from an image.
struct CIRectangleDetector {
    
    /// Detects rectangles from the given image on iOS 10.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest detected rectangle on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> ())) {
        let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: CIContext(options: nil), options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        guard let rectangleFeatures = rectangleDetector?.features(in: image) as? [CIRectangleFeature] else {
            completion(nil)
            return
        }
        
        guard let biggest = rectangleFeatures.biggest() else {
            completion(nil)
            return
        }
        
        let biggestRectangle = Quadrilateral(rectangleFeature: biggest)
        
        completion(biggestRectangle)
    }
    
}
