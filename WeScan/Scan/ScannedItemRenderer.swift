//
//  ScannedItemRenderer.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 09/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public struct ScannedItemRendererOptions{
    let targetSize:CGSize
}

public class ScannedItemRenderer{
    
    public func render(scannedItem:ScannedItem, completion: @escaping (_ image:UIImage?)->Void){
        DispatchQueue.global(qos: .userInitiated).async {
            let originalImage = scannedItem.originalImage
            let image = originalImage.applyingPortraitOrientation()
            
            guard let quad = scannedItem.quad,
                let ciImage = CIImage(image: image) else {
                    // Return the original image
                    DispatchQueue.main.async { completion(image) }
                    return
            }
            
            var cartesianScaledQuad = quad.toCartesian(withHeight: image.size.height)
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
            
            if scannedItem.colorOption == .grayscale{
                if let grayscaleImage = CIImage.init(image: uiImage)?.applyingAdaptiveThreshold(){
                    uiImage = grayscaleImage
                }
            }
            
            if scannedItem.rotation != 0.0{
                uiImage = uiImage.rotated(by: Measurement(value: scannedItem.rotation, unit: .degrees))
            }
            
            DispatchQueue.main.async { completion(uiImage.withFixedOrientation()) }
        }
    }
    
}
