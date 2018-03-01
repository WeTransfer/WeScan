//
//  Error.swift
//  Scanner
//
//  Created by Boris Emorine on 2/28/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation

enum WeScanError: Error {
    case authorization
    case inputDevice
    case capture
    case noRectangle
    case ciImageCreation
}

extension WeScanError: LocalizedError {
    
    var errorDescription: String {
        switch self {
        case .authorization:
            return "Failed to get the user's authorization for camera."
        case .inputDevice:
            return "Could not setup input device."
        case .capture:
            return "Could not capture pitcure."
        case .noRectangle:
            return "Tried capturing while no rectangle were detected."
        case .ciImageCreation:
            return "Internal Error - Could not create CIImage"
        }
    }

}
