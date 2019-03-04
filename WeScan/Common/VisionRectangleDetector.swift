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

	private static func completeImageRequest(for request: VNImageRequestHandler, width: CGFloat, height: CGFloat, completion: @escaping ((Quadrilateral?) -> Void)) {
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
					.scaledBy(x: width, y: height)

				completion(biggest.applying(transform))
			})

			rectDetectRequest.minimumConfidence = 0.8
			rectDetectRequest.maximumObservations = 15

			return rectDetectRequest
		}()

		// Send the requests to the request handler.
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try request.perform([rectangleDetectionRequest])
			} catch {
				completion(nil)
				return
			}
		}

	}
	static func rectangle(forPixelBuffer pixelBuffer: CVPixelBuffer, completion: @escaping ((Quadrilateral?) -> Void)) {
		let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
		VisionRectangleDetector.completeImageRequest(
			for: imageRequestHandler,
			width: CGFloat(CVPixelBufferGetWidth(pixelBuffer)),
			height: CGFloat(CVPixelBufferGetHeight(pixelBuffer)),
			completion: completion)
	}
    
    /// Detects rectangles from the given image on iOS 11 and above.
    ///
    /// - Parameters:
    ///   - image: The image to detect rectangles on.
    /// - Returns: The biggest rectangle detected on the image.
	static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
        let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])
				VisionRectangleDetector.completeImageRequest(
					for: imageRequestHandler, width: image.extent.width,
					height: image.extent.height, completion: completion)
    }
    
}
