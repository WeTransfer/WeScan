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
        self.view.backgroundColor = UIColor.blue
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.text = "Hello"
        self.view.addSubview(label)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Scanned page did appear")
        self.render()
    }
    
    private func render(){
        
        // TODO: This code was copied from the EditScanViewController... we need to make it common
        guard let quad = self.scannedItem.quad,
            let ciImage = CIImage(image: self.scannedItem.picture) else {
                // TODO: Return error!
                return
        }
        
        let scaledQuad = quad.scale(quadView.bounds.size, self.scannedItem.picture.size)
        self.quad = scaledQuad
        
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
            ])
        
        let enhancedImage = filteredImage.applyingAdaptiveThreshold()?.withFixedOrientation()
        
        var uiImage: UIImage!
        
        // Let's try to generate the CGImage from the CIImage before creating a UIImage.
        if let cgImage = CIContext(options: nil).createCGImage(filteredImage, from: filteredImage.extent) {
            uiImage = UIImage(cgImage: cgImage)
        } else {
            uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        }
        
        let finalImage = uiImage.withFixedOrientation()
        
        let results = ImageScannerResults(originalImage: image, scannedImage: finalImage, enhancedImage: enhancedImage, doesUserPreferEnhancedImage: false, detectedRectangle: scaledQuad)
        
    }


}
