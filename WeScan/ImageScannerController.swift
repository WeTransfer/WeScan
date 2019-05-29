//
//  ImageScannerController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

public struct ImageScannerOptions{
    public let scanMultipleItems:Bool
    public let allowAutoScan:Bool
    public let allowTapToFocus:Bool
    public let defaultColorRenderOption:ScannedItemColorOption
    
    public init(scanMultipleItems:Bool = true, allowAutoScan:Bool = true, allowTapToFocus:Bool = true, defaultColorRenderOption:ScannedItemColorOption = .color) {
        self.scanMultipleItems = scanMultipleItems
        self.allowAutoScan = allowAutoScan
        self.allowTapToFocus = allowTapToFocus
        self.defaultColorRenderOption = defaultColorRenderOption
    }
}

/// A set of methods that your delegate object must implement to interact with the image scanner interface.
public protocol ImageScannerControllerDelegate: NSObjectProtocol {
    
    /// Tells the delegate that the user scanned a document.
    ///
    /// - Parameters:
    ///   - scanner: The scanner controller object managing the scanning interface.
    ///   - sessuib: The result multi page scan session with the ScannedItem objects
    /// - Discussion: Your delegate's implementation of this method should dismiss the image scanner controller.
    func imageScannerController(_ scanner:ImageScannerController, didFinishWithSession session:MultiPageScanSession)
    
    /// Tells the delegate that the user cancelled the scan operation.
    ///
    /// - Parameters:
    ///   - scanner: The scanner controller object managing the scanning interface.
    /// - Discussion: Your delegate's implementation of this method should dismiss the image scanner controller.
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController)
    
    /// Tells the delegate that an error occured during the user's scanning experience.
    ///
    /// - Parameters:
    ///   - scanner: The scanner controller object managing the scanning interface.
    ///   - error: The error that occured.
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error)
}

/// A view controller that manages the full flow for scanning documents.
/// The `ImageScannerController` class is meant to be presented. It consists of a series of 3 different screens which guide the user:
/// 1. Uses the camera to capture an image with a rectangle that has been detected.
/// 2. Edit the detected rectangle.
/// 3. Review the cropped down version of the rectangle.
public final class ImageScannerController: UINavigationController {
    
    /// The object that acts as the delegate of the `ImageScannerController`.
    weak public var imageScannerDelegate: ImageScannerControllerDelegate?
    
    // MARK: - Life Cycle
    
    /// A black UIView, used to quickly display a black screen when the shutter button is presseed.
    internal let blackFlashView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public required init(options:ImageScannerOptions?) {
        let scannerViewController = ScannerViewController(scanSession:nil, options:options)
        super.init(rootViewController: scannerViewController)
        scannerViewController.delegate = self
        navigationBar.tintColor = .black
        navigationBar.isTranslucent = false
        self.view.addSubview(blackFlashView)
        setupConstraints()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let blackFlashViewConstraints = [
            blackFlashView.topAnchor.constraint(equalTo: view.topAnchor),
            blackFlashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: blackFlashView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: blackFlashView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(blackFlashViewConstraints)
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension ImageScannerController:ScannerViewControllerDelegate{
    
    func scannerViewController(_ scannerViewController: ScannerViewController, didFail withError: Error) {
        self.imageScannerDelegate?.imageScannerController(self, didFailWithError: withError)
    }
    
    func scannerViewControllerDidCancel(_ scannerViewController: ScannerViewController) {
        self.imageScannerDelegate?.imageScannerControllerDidCancel(self)
    }
    
    func scannerViewController(_ scannerViewController: ScannerViewController, reviewItems inSession: MultiPageScanSession) {
        let multipageScanViewController = MultiPageScanSessionViewController(scanSession: inSession)
        multipageScanViewController.delegate = self
        self.pushViewController(multipageScanViewController, animated: true)
    }
}

extension ImageScannerController:MultiPageScanSessionViewControllerDelegate{
    
    public func multiPageScanSessionViewController(_ multiPageScanSessionViewController: MultiPageScanSessionViewController, finished session: MultiPageScanSession) {
        self.imageScannerDelegate?.imageScannerController(self, didFinishWithSession: session)
    }
}
