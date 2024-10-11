//
//  UIImage+Orientation.swift
//  WeScan
//
//  Created by Boris Emorine on 2/16/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    /// Data structure to easily express rotation options.
    struct RotationOptions: OptionSet {
        let rawValue: Int

        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }

    /// Returns the same image with a portrait orientation.
    func applyingPortraitOrientation() -> UIImage {
        switch imageOrientation {
        case .up:
            return rotated(by: Measurement(value: Double.pi, unit: .radians), options: []) ?? self
        case .down:
            return rotated(by: Measurement(value: Double.pi, unit: .radians), options: [.flipOnVerticalAxis, .flipOnHorizontalAxis]) ?? self
        case .left:
            return self
        case .right:
            return rotated(by: Measurement(value: Double.pi / 2.0, unit: .radians), options: []) ?? self
        default:
            return self
        }
    }

    /// Rotate the image by the given angle, and perform other transformations based on the passed in options.
    ///
    /// - Parameters:
    ///   - rotationAngle: The angle to rotate the image by.
    ///   - options: Options to apply to the image.
    /// - Returns: The new image rotated and optionally flipped (@see options).
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        let cgImageSize = CGSize(width: cgImage.width, height: cgImage.height)
        var rect = CGRect(origin: .zero, size: cgImageSize).applying(transform)
        rect.origin = .zero

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)

        let image = renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)

            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))

            let drawRect = CGRect(origin: CGPoint(x: -cgImageSize.width / 2.0, y: -cgImageSize.height / 2.0), size: cgImageSize)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }

        return image
    }

    /// Rotates the image based on the information collected by the accelerometer
    func withFixedOrientation() -> UIImage {
        var imageAngle: Double = 0.0

        var shouldRotate = true
        switch CaptureSession.current.editImageOrientation {
        case .up:
            shouldRotate = false
        case .left:
            imageAngle = Double.pi / 2
        case .right:
            imageAngle = -(Double.pi / 2)
        case .down:
            imageAngle = Double.pi
        default:
            shouldRotate = false
        }

        if shouldRotate,
            let finalImage = rotated(by: Measurement(value: imageAngle, unit: .radians)) {
            return finalImage
        } else {
            return self
        }
    }

}
extension UIImage {
    // Rotate the image if needed based on the device's orientation when the image was captured
    func rotateToPortraitIfNeeded(deviceOrientation: UIDeviceOrientation) -> UIImage? {
        switch deviceOrientation {
        case .landscapeLeft:
            // Rotate the image 90 degrees clockwise (landscape left)
            return self.rotate(radians: .pi / 2)
        case .landscapeRight:
            // Rotate the image 90 degrees counterclockwise (landscape right)
            return self.rotate(radians: -.pi / 2)
        case .portraitUpsideDown:
            // Rotate the image 180 degrees (upside down)
            return self.rotate(radians: .pi)
        case .portrait, .faceUp, .faceDown, .unknown:
            // No need to rotate for portrait or unknown orientations
            return self
        @unknown default:
            return self
        }
    }

    // Helper function to rotate the image by a given angle
    private func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians)).size
        
        // Ensure no subpixel issues by rounding the size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()

        // Move origin to the center of the image to rotate around the center
        context?.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate the image context
        context?.rotate(by: radians)
        // Draw the image in the rotated context
        self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2,
                             width: self.size.width, height: self.size.height))

        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage
    }
}
extension UIView {
    func rotateViewBasedOnDeviceOrientation(deviceOrientation: UIDeviceOrientation) {
        var rotationAngle: CGFloat = 0

        switch deviceOrientation {
        case .landscapeLeft:
            // Rotate by 90 degrees clockwise for landscape left
            rotationAngle = .pi / 2
        case .landscapeRight:
            // Rotate by 90 degrees counterclockwise for landscape right
            rotationAngle = -.pi / 2
        case .portraitUpsideDown:
            // Rotate by 180 degrees for upside-down portrait
            rotationAngle = .pi
        case .portrait, .faceUp, .faceDown, .unknown:
            // No rotation needed
            rotationAngle = 0
        @unknown default:
            rotationAngle = 0
        }

        // Apply the rotation transformation to the view
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}
