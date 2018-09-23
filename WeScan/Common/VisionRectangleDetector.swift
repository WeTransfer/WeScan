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
    /// - Returns: The biggest detected rectangle on the image.
    static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> ())) {
      
        let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])

        // Create the rectangle request, and, if found, return the biggest rectangle (else return nothing).
        let rectangleDetectionRequest: VNDetectRectanglesRequest = {
            let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
                if error == nil {
                  
                    guard let results = request.results as? [VNRectangleObservation] else { return }
                
                    let quads: [Quadrilateral] = results.map({ observation in
                        return Quadrilateral(topLeft: observation.topLeft, topRight: observation.topRight, bottomRight: observation.bottomRight, bottomLeft: observation.bottomLeft)
                    })

                    guard let biggest = results.count > 1 ? quads.biggest() : quads.first else { return }
                    
                    let transform = CGAffineTransform.identity
                        .scaledBy(x: image.extent.size.width, y: image.extent.size.height)
                  
                    completion(biggest.applying(transform))
                    
                } else { completion(nil) }
            })

            rectDetectRequest.minimumConfidence = 0.8
            rectDetectRequest.maximumObservations = 15

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
    }
    
}
