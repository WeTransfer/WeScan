//
//  MultiPageScanSession.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public struct ScannedItem:Equatable{
    let originalImage:UIImage
    var quad:Quadrilateral?
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
    
}
