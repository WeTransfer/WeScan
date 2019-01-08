//
//  ScannedPageViewController.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

class ScannedPageViewController: UIViewController {

    private var scannedItem:ScannedItem
    private var renderedImage:UIImage?
    
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
    
    public func reRedender(item:ScannedItem){
        self.renderedImage = nil
        self.scannedItem = item
        self.render()
    }
    
    private func render(){
        if (renderedImage == nil){
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
            
            self.renderedImage = uiImage.withFixedOrientation()
            
            let imageView = UIImageView(image: self.renderedImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            
            let constraints = [imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
                               imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
                               imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
                               imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)]
            self.view.addSubview(imageView)
            NSLayoutConstraint.activate(constraints)
            //imageView.image = self.renderedImage
            
            //let results = ImageScannerResults(originalImage: image, scannedImage: finalImage, enhancedImage: enhancedImage, doesUserPreferEnhancedImage: false, detectedRectangle: scaledQuad)
        }
    }


}
