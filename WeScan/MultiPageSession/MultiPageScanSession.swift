//
//  MultiPageScanSession.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public struct ScannedItem{
    let picture:UIImage
    let quad:Quadrilateral?
}

public class MultiPageScanSession {
    
    public private(set) var scannedItems:Array<ScannedItem> = []
    
    public func add(picture:UIImage, withQuad quad: Quadrilateral?) {
        let item = ScannedItem(picture: picture, quad: quad)
        self.scannedItems.append(item)
    }
    
}
