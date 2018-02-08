//
//  ScannerViewController.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

public class ScannerViewController: UIViewController {
    
    private var captureSessionManager: CaptureSessionManager?
    private let videoPreviewlayer = AVCaptureVideoPreviewLayer()
    private let quadView = QuadrilateralView()

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.addSublayer(videoPreviewlayer)
        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewlayer)
        captureSessionManager?.delegate = self
        
        view.addSubview(quadView)
        
        quadView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: quadView.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: quadView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSessionManager?.start()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewlayer.frame = view.layer.bounds
    }
    
}

extension ScannerViewController: RectangleDetectionDelegateProtocol {
    
    func didDetectQuad(_ quad: Quadrilateral, _ imageSize: CGSize) {
        quadView.drawQuadrilateral(quad: quad, imageSize: imageSize)
    }
    
}
