//
//  UIDeviceOrientation+Utils.swift
//  WeScan
//
//  Created by Boris Emorine on 2/13/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

extension AVCaptureVideoOrientation {
    
    /// Maps UIDeviceOrientation to AVCaptureVideoOrientation
    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait:
            self.init(deviceOrientation: .portrait)
        case .portraitUpsideDown:
            self.init(deviceOrientation: .portraitUpsideDown)
        case .landscapeLeft:
            self.init(deviceOrientation: .landscapeLeft)
        case .landscapeRight:
            self.init(deviceOrientation: .landscapeRight)
        case .faceUp:
            self.init(deviceOrientation: .portrait)
        case .faceDown:
            self.init(deviceOrientation: .portraitUpsideDown)
        default:
            self.init(deviceOrientation: .portrait)
        }
    }
    
}
