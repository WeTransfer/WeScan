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
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral)
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error)
}

final class CaptureSessionManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate  {
    
    private let videoPreviewLayer: AVCaptureVideoPreviewLayer
    private let captureSession = AVCaptureSession()
    private let rectangleFunnel = RectangleFeaturesFunnel()
    weak var delegate: RectangleDetectionDelegateProtocol?
    private var displayedRectangleResult: RectangleDetectorResult?
    private var photoOutput = AVCapturePhotoOutput()
    private var detects = true
    
    /// The number of times no rectangles have been found in a row.
    private var noRectangleCount = 0
    
    /// The minimum number of time required by `noRectangleCount` to validate that no rectangles have been found.
    private let noRectangleThreshold = 3
    
    // MARK: Life Cycle
    
    init?(videoPreviewLayer: AVCaptureVideoPreviewLayer) {
        self.videoPreviewLayer = videoPreviewLayer
        super.init()
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        photoOutput.isHighResolutionCaptureEnabled = true
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard let inputDevice = AVCaptureDevice.default(for: AVMediaType.video),
            let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
            captureSession.canAddInput(deviceInput),
            captureSession.canAddOutput(photoOutput),
            captureSession.canAddOutput(videoOutput) else {
                let error = NSError(domain: "Could not setup input device.", code: 0, userInfo: nil)
                delegate?.captureSessionManager(self, didFailWithError: error)
                return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
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
                self?.start()
            })
        }
        else if authorizationStatus == .authorized {
            self.captureSession.startRunning()
            detects = true
        } else {
            let error = NSError(domain: "Not authorized to use Camera.", code: 0, userInfo: ["authorizationStatus" : authorizationStatus])
            delegate?.captureSessionManager(self, didFailWithError: error)
        }
    }
    
    internal func stop() {
        captureSession.stopRunning()
    }
    
    internal func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        
        if let photoOutputConnection = self.photoOutput.connection(with: .video) {
            photoOutputConnection.videoOrientation = UIDevice.current.orientation.toAVCaptureVideoOrientation()
        }
        
       photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard detects == true else {
            return
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let videoOutputImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageSize = videoOutputImage.extent.size
        
        guard let rectangle = RectangleDetector.rectangle(forImage: videoOutputImage) else {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.noRectangleCount += 1
                
                if strongSelf.noRectangleCount > strongSelf.noRectangleThreshold {
                    strongSelf.displayedRectangleResult = nil
                    strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: nil, imageSize)
                }
            }
            return
        }
        
        noRectangleCount = 0
        
        rectangleFunnel.add(rectangle, currentlyDisplayedRectangle: displayedRectangleResult?.rectangle) { (rectangle) in
            displayRectangleResult(rectangleResult: RectangleDetectorResult(rectangle: rectangle, imageSize: imageSize))
        }
    }
    
    @discardableResult private func displayRectangleResult(rectangleResult: RectangleDetectorResult) -> Quadrilateral {
        displayedRectangleResult = rectangleResult
        
        let quad = Quadrilateral(rectangleFeature: rectangleResult.rectangle).toCartesian(withHeight: rectangleResult.imageSize.height)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.captureSessionManager(strongSelf, didDetectQuad: quad, rectangleResult.imageSize)
        }
        
        return quad
    }

}

extension CaptureSessionManager: AVCapturePhotoCaptureDelegate {

    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        // TODO: FIX iOS 10.0
        
        if let error = error {
            // TODO: Handle Errors
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                if let image = UIImage(data: imageData) {
//                    delegate?.captureSessionManager(self, didCapturePicture:  image)
                }
            }
        }
        
    }
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            delegate?.captureSessionManager(self, didFailWithError: error)
            return
        }
        
        guard let displayedRectangleResult = displayedRectangleResult else {
            return
        }
        
        delegate?.didStartCapturingPicture(for: self)
        
        DispatchQueue.global(qos: .background).async {
            if let imageData = photo.fileDataRepresentation(),
                var image = UIImage(data: imageData) {
                
                self.detects = false
                
                var angle: CGFloat = 0.0
                
                switch image.imageOrientation {
                case .right:
                    angle = CGFloat.pi / 2
                    break
                case .up:
                    angle = CGFloat.pi
                    break
                default:
                    break
                }
                
                image = image.withPortraitOrientation()
                
                let quad = self.displayRectangleResult(rectangleResult: displayedRectangleResult)
                let scaledQuad = quad.scale(displayedRectangleResult.imageSize, image.size, withRotationAngle: angle)
                
                DispatchQueue.main.async {
                    self.delegate?.captureSessionManager(self, didCapturePicture: image, withQuad: scaledQuad)
                }
            }
            
        }
    }
}

struct RectangleDetectorResult {
    
    let rectangle: CIRectangleFeature
    let imageSize: CGSize
    
}
