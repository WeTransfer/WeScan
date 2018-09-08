//
//  CaptureSession.swift
//  WeScan
//
//  Created by Julian Schiavo on 31/7/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

/// A class containing global variables and settings for this capture session
final class CaptureSession {
    
    static let current = CaptureSession()
    
    /// Whether auto scan is enabled or not
    var autoScanEnabled: Bool
    
    /// The orientation of the captured image
    var editImageOrientation: CGImagePropertyOrientation
    
    private init(autoScanEnabled: Bool = true, editImageOrientation: CGImagePropertyOrientation = .downMirrored) {
        self.autoScanEnabled = autoScanEnabled
        self.editImageOrientation = editImageOrientation
    }
    
}
