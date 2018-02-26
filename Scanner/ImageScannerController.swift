//
//  ImageScannerController.swift
//  Scanner
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ImageScannerControllerDelegate: NSObjectProtocol {
    
    /// Called by the image scanner when the user has scanned an image.
    ///
    /// - Parameters:
    ///   - scanner: The scanner object calling this function.
    ///   - results: The results of the user scanning with the camera.
    func scanner(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults)
    
}

/// The `ImageScannerController` class is meant to be presented. It consists of a series of 3 different screens which guide the user:
/// 1. Uses the camera to capture an image with a rectangle that has been detected.
/// 2. Edit the detected rectangle.
/// 3. Review the cropped down version of the rectangle.
public class ImageScannerController: UINavigationController {
    
    /// The object that acts as the delegate of the `ImageScannerController`.
    weak public var imageScannerDelegate: ImageScannerControllerDelegate?
    
    // MARK - Life Cycle
    
    public required init() {
        let scannerViewController = ScannerViewController()
        super.init(rootViewController: scannerViewController)
        navigationBar.tintColor = .black
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

/// Data structure containing information about a scan.
public struct ImageScannerResults {
    
    /// The original image taken by the user.
    var originalImage: UIImage
    
    /// The deskewed and cropped orignal image using the detected rectangle.
    var scannedImage: UIImage
    
    /// The detected rectangle which was used to generate the `scannedImage`.
    var detectedRectangle: Quadrilateral
    
}
