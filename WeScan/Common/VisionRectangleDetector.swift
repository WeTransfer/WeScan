//
//  VisionRectangleDetector.swift
//  WeScan
//
//  Created by Julian Schiavo on 28/7/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Vision
import Foundation

/// Class used to detect rectangles from an image.
@available(iOS 11.0, *)
struct VisionRectangleDetector {
    
    /// Detects rectangles from the given image on iOS 11 and above.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest rectangle detected on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
      
        let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])

        // Create the rectangle request, and, if found, return the biggest rectangle (else return nothing).
        let rectangleDetectionRequest: VNDetectRectanglesRequest = {
            let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
                guard error == nil, let results = request.results as? [VNRectangleObservation], !results.isEmpty else {
                    completion(nil)
                    return
                }
                
                let quads: [Quadrilateral] = results.map(Quadrilateral.init)

                guard let biggest = quads.biggest() else { // Can't fail because guard excluded empty array,
                    completion(nil)                        // but strict linter rules force to add this else case
                    return                                 // which will never be executed.
                }
                
                let transform = CGAffineTransform.identity
                    .scaledBy(x: image.extent.size.width, y: image.extent.size.height)
              
                let finalRectangle = biggest.applying(transform)
                
                completion(finalRectangle)
            })

            rectDetectRequest.minimumConfidence = 0.8
            rectDetectRequest.maximumObservations = 15

            return rectDetectRequest
        }()
        
        // Send the requests to the request handler.
        do {
            try imageRequestHandler.perform([rectangleDetectionRequest])
        } catch {
            completion(nil)
            return
        }
    }
    
}
