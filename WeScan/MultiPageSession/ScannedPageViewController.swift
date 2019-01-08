//
//  ScannedPageViewController.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

class ScannedPageViewController: UIViewController {

    private let scannedItem:ScannedItem
    
    init(scannedItem:ScannedItem){
        self.scannedItem = scannedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Scanned page did appear")
        self.render()
    }
    
    private func render(){
        
        let image = scannedItem.picture.applyingPortraitOrientation()
        
        guard let quad = scannedItem.quad,
            let ciImage = CIImage(image: image) else {
                // TODO: Return error
                return
        }
        
        //let scaledQuad = quad.scale(quadView.bounds.size, image.size)
        //self.quad = scaledQuad
        
        var cartesianScaledQuad = quad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        //let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
        
        var uiImage: UIImage!
        
        // Let's try to generate the CGImage from the CIImage before creating a UIImage.
        if let cgImage = CIContext(options: nil).createCGImage(filteredImage, from: filteredImage.extent) {
            uiImage = UIImage(cgImage: cgImage)
        } else {
            uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        }
        
        let finalImage = uiImage.withFixedOrientation()
        
        let imageView = UIImageView.init(image: finalImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        
        self.view.addSubview(imageView)
        //let results = ImageScannerResults(originalImage: image, scannedImage: finalImage, enhancedImage: enhancedImage, doesUserPreferEnhancedImage: false, detectedRectangle: scaledQuad)
    }


}
