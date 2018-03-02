//
//  UIDeviceOrientation+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

extension UIDeviceOrientation {
    
    /// Maps `UIDeviceOrientation` to `AVCaptureVideoOrientation`.
    ///
    /// - Returns: The `AVCaptureVideoOrientation` that maps to the `UIDeviceOrientation`.
    func toAVCaptureVideoOrientation() -> AVCaptureVideoOrientation {
        switch self {
        case .portrait:
            return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .faceUp:
            return AVCaptureVideoOrientation.portrait
        case .faceDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        default:
            return AVCaptureVideoOrientation.portrait
        }
    }
    
}
