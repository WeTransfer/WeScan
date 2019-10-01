//
//  CGImagePropertyOrientation.swift
//  WeScan
//
//  Created by Yang Chen on 5/21/19.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up:
            self = .up
        case .upMirrored:
            self = .upMirrored
        case .down:
            self = .down
        case .downMirrored:
            self = .downMirrored
        case .left:
            self = .left
        case .leftMirrored:
            self = .leftMirrored
        case .right:
            self = .right
        case .rightMirrored:
            self = .rightMirrored
        @unknown default:
            assertionFailure("Unknow orientation, falling to default")
            self = .right
        }
    }

    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .up
        case .portraitUpsideDown: self = .down
        case .landscapeLeft: self = .left
        case .landscapeRight: self = .right
        case .unknown: self = .up
        case .faceUp: self = .up
        case .faceDown: self = .up
        @unknown default:
            assertionFailure("Unknow orientation, falling to default")
            self = .right
        }
    }

    init(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .up
        case .portraitUpsideDown: self = .up
        case .landscapeLeft: self = .left
        case .landscapeRight: self = .right
        case .unknown: self = .up
        @unknown default:
            assertionFailure("Unknow orientation, falling to default")
            self = .right
        }
    }
}
