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

public struct ScannedItemRenderOptions:Equatable{
    var rotation:Double
    var colorOption:ScannedItemColorOption
}

public struct ScannedItem:Equatable{
    let originalImage:UIImage
    let quad:Quadrilateral?
    var renderOptions:ScannedItemRenderOptions?
}

public class MultiPageScanSession {
    
    public private(set) var scannedItems:Array<ScannedItem> = []
    
    public func add(item:ScannedItem){
        self.scannedItems.append(item)
    }
    
    public func replace(item:ScannedItem, with newItem:ScannedItem){
        if let index = self.scannedItems.index(of:item){
            self.scannedItems[index] = newItem
        }
    }
    
    public func remove(index:Int){
        self.scannedItems.remove(at: index)
    }
    
    public func update(scannedItem:ScannedItem, with newOptions:ScannedItemRenderOptions){
        if let index = self.scannedItems.index(of:scannedItem){
            self.scannedItems[index].renderOptions = newOptions
        }
    }
    
}
