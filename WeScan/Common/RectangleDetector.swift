//
//  RectangleDetector.swift
//  WeScan
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Vision
import Foundation
import AVFoundation

/// Class used to detect rectangles from an image.
struct RectangleDetector {
    
    /// Detects rectangles from the given image.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest detected rectangle on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> ())) {
        if #available(iOS 11.0, *) {
            let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])
            var biggestRectangle: Quadrilateral? = nil
            
            // Create the rectangle request, and, if found, return the biggest rectangle (else return nothing).
            let rectangleDetectionRequest: VNDetectRectanglesRequest = {
                let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
                    if error == nil {
                        guard let results = request.results as? [VNRectangleObservation] else { return }
                        guard let biggest = results.count > 1 ? results.biggest() : results.first else { return }
                        
                        let transform = CGAffineTransform.identity
                            .scaledBy(x: 1, y: -1)
                            .translatedBy(x: 0, y: -image.extent.size.height)
                            .scaledBy(x: image.extent.size.width, y: image.extent.size.height)
                        
                        biggestRectangle = Quadrilateral(topLeft: biggest.topLeft.applying(transform), topRight: biggest.topRight.applying(transform), bottomRight: biggest.bottomRight.applying(transform), bottomLeft: biggest.bottomLeft.applying(transform))
                        completion(biggestRectangle)
                        
                    } else { completion(nil) }
                })
                rectDetectRequest.minimumConfidence = 0.7
                rectDetectRequest.maximumObservations = 8
                return rectDetectRequest
            }()
            
            // Send the requests to the request handler.
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try imageRequestHandler.perform([rectangleDetectionRequest])
                } catch let error as NSError {
                    print("Failed to perform image request: \(error)")
                    completion(nil)
                    return
                }
            }
            
        } else {
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
    
}
