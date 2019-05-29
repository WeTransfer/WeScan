//
//  MultiPageScanSession.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public enum ScannedItemColorOption{
    case color
    case grayscale
}

/// Data structure containing information about one page scanned
public class ScannedItem{
    
    /// The original image taken by the user, prior to the cropping applied by WeScan.
    let originalImage:UIImage
    
    /// The detected rectangle which was used to generate the `scannedImage`.
    var quad:Quadrilateral?
    
    /// The rotation applied to the resulting image
    var rotation:Double = 0.0
    
    /// The color preference for the output of this image
    var colorOption:ScannedItemColorOption = .color
    
    /// The deskewed and cropped orignal image using the detected rectangle, without any filters.
    var renderedImage:UIImage? = nil
    
    public init(originalImage:UIImage, quad:Quadrilateral? = nil, colorOption:ScannedItemColorOption = .color) {
        self.originalImage = originalImage
        self.quad = quad
        self.colorOption = colorOption
    }
}

public class MultiPageScanSession {
    
    public private(set) var scannedItems:Array<ScannedItem> = []
    
    public init(){}
    
    public func add(item:ScannedItem){
        self.scannedItems.append(item)
    }
    
    public func remove(index:Int){
        self.scannedItems.remove(at: index)
    }
    
}
