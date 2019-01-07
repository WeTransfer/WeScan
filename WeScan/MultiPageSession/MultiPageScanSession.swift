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
    let quadViewBounds:CGRect
}

public class MultiPageScanSession {
    
    public private(set) var scannedItems:Array<ScannedItem> = []
    
    public func add(picture:UIImage, quuadViewBounds:CGRect, withQuad quad: Quadrilateral?) {
        let item = ScannedItem(picture: picture, quad: quad, quadViewBounds:quuadViewBounds)
        self.scannedItems.append(item)
    }
    
    public func add(item:ScannedItem){
        self.scannedItems.append(item)
    }
    
}
