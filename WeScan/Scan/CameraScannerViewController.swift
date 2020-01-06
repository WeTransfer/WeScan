//
//  CameraScannerViewController.swift
//  WeScan
//
//  Created by Chawatvish Worrapoj on 6/1/2563 BE.
//  Copyright © 2563 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraScannerViewProtocol {
    func capture()
    func toggleFlash()
}

class CameraScannerView: UIViewController, CameraScannerViewProtocol {
    
    private var captureSessionManager: CaptureSessionManager?
    private let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    /// The view that shows the focus rectangle (when the user taps to focus, similar to the Camera app)
    private var focusRectangle: FocusRectangleView!
    
    /// The view that draws the detected rectangles.
    private let quadView = QuadrilateralView()
    
    /// Whether flash is enabled
    private var flashEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CaptureSession.current.isEditing = false
        quadView.removeQuadrilateral()
        captureSessionManager?.start()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = view.layer.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        captureSessionManager?.stop()
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.torchMode == .on {
            toggleFlash()
        }
    }
    
    private func setupView() {
        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewLayer)
        captureSessionManager?.delegate = self
//
//        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: Notification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
    }
    
    
    
    
    
    
    func capture() {
    }
    
    func toggleFlash() {
    }
}

// Custom UI
extension CameraScannerView {
    
}
