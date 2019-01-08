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
        /*
        guard let quad = self.scannedItem.quad,
            let ciImage = CIImage(image: self.scannedItem.picture) else {
                // TODO: Return an error here!
                return
        }
        
        let scaledQuad = quad.scale(scannedItem.quadViewBounds.size, scannedItem.picture.size)
        
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: scannedItem.picture.size.height)
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
        
        let finalImage = uiImage.withFixedOrientation()
        
        let imageView = UIImageView(image: finalImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.view.addSubview(imageView)
        */
    }


}
