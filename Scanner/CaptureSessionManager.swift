//
//  CaptureManager.swift
//  Scanner
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

protocol RectangleDetectionDelegateProtocol: NSObjectProtocol {
    
    func didDetectQuad(_ quad: Quadrilateral?, _ imageSize: CGSize)
    
}

internal class CaptureSessionManager: NSObject  {
    
    private let videoPreviewLayer: AVCaptureVideoPreviewLayer
    private let captureSession = AVCaptureSession()
    private let rectangleFunnel = RectangleFeaturesFunnel()
    weak var delegate: RectangleDetectionDelegateProtocol?
    private var displayedRectangle: CIRectangleFeature?
    private let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: CIContext(options: nil), options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
    /// Initialize a ImageCaptureManager instance
    
    // MARK: Life Cycle
    
    init?(videoPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.videoPreviewLayer = videoPreviewLayer
        super.init()
        
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let photOutput = AVCapturePhotoOutput()
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photOutput),
            captureSession.canAddOutput(videoOutput) else {
                // TODO: Handle Error
                return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photOutput)
        captureSession.addOutput(videoOutput)
        
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_ouput_queue"))
        
        captureSession.commitConfiguration()
    }
    
    // MARK: Capture Session Life Cycle
    
    internal func start() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {[weak self] (granted) in
                if granted {
                    self?.captureSession.startRunning()
                }
            })
        }
        else if authorizationStatus == .authorized {
            self.captureSession.startRunning()
        }
        else {
            //TODO: present error
        }
    }
    
    internal func stop() {
        captureSession.stopRunning()
    }

}

extension CaptureSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let videoOutputImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        guard let rectangeFeatures = rectangleDetector?.features(in: videoOutputImage) as? [CIRectangleFeature] else {
            return
        }
        
        guard let biggestRectangle = rectangeFeatures.biggestRectangle() else {
            return
        }
        
        let imageSize = videoOutputImage.extent.size
        
        rectangleFunnel.add(biggestRectangle, previouslyDisplayedRectangleFeature: displayedRectangle) { (rectangle) in
            
            displayedRectangle = rectangle
            
            
            guard let bestRectangle = rectangle else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didDetectQuad(nil, imageSize)
                }
                return
            }
            
            let quad = Quadrilateral(rectangleFeature: bestRectangle).toCartesian(withHeight: imageSize.height)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didDetectQuad(quad, imageSize)
            }
        }
    }
}
