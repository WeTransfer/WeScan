//
//  ImageToPDF.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 08/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public class ImageToPDF {
    
    public static func createPDFWith(images:Array<UIImage>, inPath:String){
        
        UIGraphicsBeginPDFContextToFile(inPath, CGRect.zero, nil);
        
        images.forEach { (image) in
            UIGraphicsBeginPDFPageWithInfo(CGRect(x:0, y:0, width:image.size.width, height:image.size.height), nil);
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        UIGraphicsEndPDFContext();
    }
    
    public static func createPDFFrom(scanSession:MultiPageScanSession){
        // TODO: Call the delegate and move this code somewhere else
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        path = path + "/file.pdf"
        var images = Array<UIImage>()
        scanSession.scannedItems.forEach { (scannedItem) in
            scannedItem.renderQuadImage(completion: { (image) in
                if let renderedImage = image {
                    images.append(renderedImage)
                } else {
                    // TODO: What do we do if the image fails to render?
                }
            })
        }
        ImageToPDF.createPDFWith(images: images, inPath: path)
    }
    
}
