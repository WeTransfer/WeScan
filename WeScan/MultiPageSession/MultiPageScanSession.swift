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

public class ScannedItem{
    let originalImage:UIImage
    var quad:Quadrilateral?
    var rotation:Double = 0.0
    var colorOption:ScannedItemColorOption = .color
    var renderedImage:UIImage? = nil
    
    init(originalImage:UIImage, quad:Quadrilateral?) {
        self.originalImage = originalImage
        self.quad = quad
    }
}

public class MultiPageScanSession {
    
    public private(set) var scannedItems:Array<ScannedItem> = []
    
    public func add(item:ScannedItem){
        self.scannedItems.append(item)
    }
    
    public func remove(index:Int){
        self.scannedItems.remove(at: index)
    }
    
}
