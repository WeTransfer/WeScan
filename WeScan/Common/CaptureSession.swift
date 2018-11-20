//
//  CaptureSession.swift
//  WeScan
//
//  Created by Julian Schiavo on 23/9/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

/// A class containing global variables and settings for this capture session
final class CaptureSession {
    
    static let current = CaptureSession()
    
    /// Whether the user is past the scanning screen or not (needed to disable auto scan on other screens)
    var isEditing: Bool
    
    /// The status of "auto mode". Auto mode does not allow tap to focus and tries to automatically scan a detected rectangle if it has a high enough accuracy.
    var isAutoModeEnabled: Bool
    
    /// The orientation of the captured image
    var editImageOrientation: CGImagePropertyOrientation
    
    private init(isAutoModeEnabled: Bool = true, editImageOrientation: CGImagePropertyOrientation = .up) {
        self.isEditing = false
        self.isAutoModeEnabled = isAutoModeEnabled
        self.editImageOrientation = editImageOrientation
    }
    
}

/// Extension to CaptureSession to manage the device flashlight
extension CaptureSession {
    /// The possible states that the current device's flashlight can be in
    enum FlashState {
        case on
        case off
        case unavailable
        case unknown
    }
    
    /// Toggles the current device's flashlight on or off.
    func toggleFlash() -> FlashState {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video), device.isTorchAvailable else { return .unavailable }
        
        do {
            try device.lockForConfiguration()
        } catch {
            return .unknown
        }
        
        defer {
            device.unlockForConfiguration()
        }
        
        if device.torchMode == .on {
            device.torchMode = .off
            return .off
        } else if device.torchMode == .off {
            device.torchMode = .on
            return .on
        }
        
        return .unknown
    }
}

/// Extension to CaptureSession that controls auto focus
extension CaptureSession {
    /// Sets the camera's exposure and focus point to the given point
    func setFocusPointToTapPoint(_ tapPoint: CGPoint) throws {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        try device.lockForConfiguration()
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.autoFocus) {
            device.focusPointOfInterest = tapPoint
            device.focusMode = .autoFocus
        }
        
        if device.isExposurePointOfInterestSupported, device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposurePointOfInterest = tapPoint
            device.exposureMode = .continuousAutoExposure
        }
        
        device.unlockForConfiguration()
    }
    
    /// Resets the camera's exposure and focus point to automatic
    func resetFocusToAuto() throws {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        try device.lockForConfiguration()
        
        if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) {
            device.focusMode = .continuousAutoFocus
        }
        
        if device.isExposurePointOfInterestSupported, device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposureMode = .continuousAutoExposure
        }
        
        device.unlockForConfiguration()
    }
    
    /// Removes an existing focus rectangle if one exists, optionally animating the exit
    func removeFocusRectangleIfNeeded(_ focusRectangle: FocusRectangle?, animated: Bool) {
        guard let focusRectangle = focusRectangle else { return }
        if animated {
            UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
                focusRectangle.alpha = 0.0
            }, completion: { (_) in
                focusRectangle.removeFromSuperview()
            })
        } else {
            focusRectangle.removeFromSuperview()
        }
    }
}
