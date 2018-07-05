//
//  ImageScannerResults.swift
//  WeScan
//
//  Created by Boris Emorine on 6/15/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

protocol ImageScannerResultsDelegateProtocol: NSObjectProtocol {
    
    func didUpdateResults(results: [ImageScannerResults])
    
}

public class ImageScannerResults: NSObject {
    
    /// The original image taken by the user.
    public var originalImage: UIImage
    
    /// The deskewed and cropped orignal image using the detected rectangle.
    @objc dynamic public var scannedImage: UIImage?
    
    /// The detected rectangle which was used to generate the `scannedImage`.
    public var detectedRectangle: Quadrilateral
    
    required public init(originalImage: UIImage, detectedRectangle: Quadrilateral) {
        self.originalImage = originalImage
        self.detectedRectangle = detectedRectangle
        super.init()
    }
    
    internal func generateScannedImage(completion: (() -> Void)?) throws {
        guard let ciImage = CIImage(image: originalImage) else {
            let error = ImageScannerControllerError.ciImageCreation
            throw(error)
        }
        
        var cartesianScaledQuad = detectedRectangle.toCartesian(withHeight: originalImage.size.height)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        var uiImage: UIImage!
        
        // Let's try to generate the CGImage from the CIImage before creating a UIImage.
        if let cgImage = CIContext(options: nil).createCGImage(filteredImage, from: filteredImage.extent) {
            uiImage = UIImage(cgImage: cgImage)
        } else {
            uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        }
        
        self.scannedImage = uiImage
        completion?()
    }
    
}
