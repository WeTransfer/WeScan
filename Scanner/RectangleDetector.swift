//
//  RectangleDetector.swift
//  Scanner
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

struct RectangleDetector {
    
    static func rectangle(forImage image: CIImage) -> CIRectangleFeature? {
        let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: CIContext(options: nil), options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
        
        guard let rectangeFeatures = rectangleDetector?.features(in: image) as? [CIRectangleFeature] else {
            return nil
        }
        
        guard let biggestRectangle = rectangeFeatures.biggestRectangle() else {
            return nil
        }
        
        return biggestRectangle
    }
    
}
