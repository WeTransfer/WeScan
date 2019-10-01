//
//  UIInterfaceOrientation+Utils.swift
//  WeScan
//
//  Created by Antoine Harlin on 01/10/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

extension UIInterfaceOrientation {
    var rotationAngle: CGFloat {
        switch self {
        case UIInterfaceOrientation.portrait:
            return CGFloat.pi / 2
        case UIInterfaceOrientation.portraitUpsideDown:
            return -CGFloat.pi / 2
        case UIInterfaceOrientation.landscapeLeft:
            return CGFloat.pi
        case UIInterfaceOrientation.landscapeRight:
            return CGFloat.pi * 2
        default:
            return CGFloat.pi / 2
        }
    }
}
