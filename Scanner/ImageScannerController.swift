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
    
    func scanner(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults)
    
}

public class ImageScannerController: UINavigationController {
    
    weak public var imageScannerDelegate: ImageScannerControllerDelegate?

    var allowsEditing = true
    
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

public struct ImageScannerResults {
    
    var originalImage: UIImage
    
    var scannedImage: UIImage
    
    var detectedRectangle: Quadrilateral
    
}
