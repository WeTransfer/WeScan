//
//  ScannerViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

/// The `ScannerViewController` offers an interface to give feedback to the user regarding quadrilaterals that are detected. It also gives the user the opportunity to capture an image with a detected rectangle.
final class ScannerViewController: UIViewController {
    
    private var captureSessionManager: CaptureSessionManager?
    private let videoPreviewlayer = AVCaptureVideoPreviewLayer()
    
    private var results = [ImageScannerResults]()
    private let scanOperationQueue = OperationQueue()
    
    /// The view that draws the detected rectangles.
    private let quadView = QuadrilateralView()
    
    lazy private var shutterButton: ShutterButton = {
        let button = ShutterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    lazy private var closeButton: CloseButton = {
        let button = CloseButton(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        button.addTarget(self, action: #selector(cancelImageScannerController(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var doneBarButtonItem: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.button.done", tableName: nil, bundle: Bundle(for: ImageScannerController.self), value: "Done", comment: "The right button of the ScannerViewController")
        let barButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.done, target: self, action: #selector(saveImageScannerController(_:)))
        return barButtonItem
    }()
    
    lazy private var scansButton: UIButton = {
        let button = UIButton(type: .custom)
        button.alpha = 0.0
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(pushGalleryViewController(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("wescan.scanning.title", tableName: nil, bundle: Bundle(for: ImageScannerController.self), value: "Scanning", comment: "The title of the ScannerViewController")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = doneBarButtonItem

        setupViews()
        setupConstraints()
        
        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewlayer)
        captureSessionManager?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quadView.removeQuadrilateral()
        captureSessionManager?.start()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewlayer.frame = view.layer.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.layer.addSublayer(videoPreviewlayer)
        quadView.translatesAutoresizingMaskIntoConstraints = false
        quadView.editable = false
        view.addSubview(quadView)
        view.addSubview(shutterButton)
        view.addSubview(activityIndicator)
        view.addSubview(scansButton)
    }
    
    private func setupConstraints() {
        let quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            quadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        
        var shutterButtonBottomConstraint: NSLayoutConstraint

        if #available(iOS 11.0, *) {
            shutterButtonBottomConstraint = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor, constant: 15.0)
        } else {
            shutterButtonBottomConstraint = view.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor, constant: 15.0)
        }
        
        let shutterButtonConstraints = [
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButtonBottomConstraint,
            shutterButton.widthAnchor.constraint(equalToConstant: 65.0),
            shutterButton.heightAnchor.constraint(equalToConstant: 65.0)
        ]
        
        let activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let scansButtonConstraints = [
            scansButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor),
            scansButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            scansButton.widthAnchor.constraint(equalToConstant: 50.0),
            scansButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints + shutterButtonConstraints + activityIndicatorConstraints + scansButtonConstraints)
    }
    
    private func updateScansButton() {
        guard let image = results.last?.originalImage else {
            scansButton.alpha = 0.0
            return
        }
        
        scansButton.alpha = 1.0
        scansButton.setImage(image, for: .normal)
    }
    
    private func enableUserInterface() {
        scansButton.isUserInteractionEnabled = true
        shutterButton.isUserInteractionEnabled = true
    }
    
    private func disableUserInterface() {
        scansButton.isUserInteractionEnabled = false
        shutterButton.isUserInteractionEnabled = false
    }
    
    // MARK: - Actions
    
    @objc private func captureImage(_ sender: UIButton) {
        (navigationController as? ImageScannerController)?.flashToBlack()
        shutterButton.isUserInteractionEnabled = false
        captureSessionManager?.capturePhoto()
    }
    
    @objc private func cancelImageScannerController(_ sender: UIButton) {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerControllerDidCancel(imageScannerController)
        }
    }
    
    @objc private func saveImageScannerController(_ sender: UIButton) {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: results)
        }
    }
    
    @objc private func pushGalleryViewController(_ sender: UIButton) {
        let galleryViewController = ScanGalleryViewController(with: results)
        galleryViewController.scanGalleryDelegate = self
        navigationController?.pushViewController(galleryViewController, animated: true)
    }

}

extension ScannerViewController: RectangleDetectionDelegateProtocol {
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {
        activityIndicator.stopAnimating()
        enableUserInterface()
        
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
        }
    }
    
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
        activityIndicator.startAnimating()
        quadView.removeQuadrilateral()
        disableUserInterface()
    }
    
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
        activityIndicator.stopAnimating()
        enableUserInterface()
        
        let quad = quad ?? Quadrilateral.defaultQuad(forImage: picture)
        
        let result = ImageScannerResults(originalImage: picture, detectedRectangle: quad)
        results.append(result)
        
        updateScansButton()
        
        let scanOperation = ScanOperation(withResults: result)
        scanOperationQueue.addOperation(scanOperation)
    }
        
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
        guard let quad = quad else {
            // If no quad has been detected, we remove the currently displayed one on the quadView.
            quadView.removeQuadrilateral()
            return
        }
        
        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: portraitImageSize, aspectFillInSize: quadView.bounds.size)
        let scaledImageSize = imageSize.applying(scaleTransform)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))

        let imageBounds = CGRect(x: 0.0, y: 0.0, width: scaledImageSize.width, height: scaledImageSize.height).applying(rotationTransform)
        let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: imageBounds, toCenterOfRect: quadView.bounds)

        let transforms = [scaleTransform, rotationTransform, translationTransform]
        
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: true)
    }
    
}

extension ScannerViewController: ImageScannerResultsDelegateProtocol {
    
    func didUpdateResults(results: [ImageScannerResults]) {
        self.results = results
        updateScansButton()
    }
    
}
