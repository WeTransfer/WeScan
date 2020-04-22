//
//  AVCaptureSession+Utils.swift
//  WeScan
//
//  Created by David Steppenbeck on 2020/04/22.
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import AVFoundation

extension AVCaptureSession {

    /// Safely assigns the `sessionPreset` property.
    ///
    /// The assignment will only be made if the `canSetSessionPreset(_:)` method returns `true`.
    ///
    /// - Parameters:
    ///   - preset: The `AVCaptureSession.Preset` value to be assigned.
    func safeSetSessionPreset(_ preset: AVCaptureSession.Preset) {
        if canSetSessionPreset(preset) {
            sessionPreset = preset
        }
    }

}
