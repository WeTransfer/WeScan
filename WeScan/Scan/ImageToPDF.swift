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
    
}
