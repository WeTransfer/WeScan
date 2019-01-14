//
//  ImageToPDF.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 08/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public class PDFCreator {
    
    var currentIndex = 0
    var images = Array<UIImage>()
    
    let scanSession:MultiPageScanSession
    let outputPath:String
    
    public init(scanSession:MultiPageScanSession, in path:String){
        self.scanSession = scanSession
        self.outputPath = path
    }
    
    
    private func createPDFWith(images:Array<UIImage>, inPath:String){
        
        UIGraphicsBeginPDFContextToFile(inPath, CGRect.zero, nil);
        
        images.forEach { (image) in
            UIGraphicsBeginPDFPageWithInfo(CGRect(x:0, y:0, width:image.size.width, height:image.size.height), nil);
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        UIGraphicsEndPDFContext();
    }
    
    public func createPDF(){ //completion: @escaping (Error?) -> Void, progress: @escaping (Double) ->Void){
        self.currentIndex = 0
        self.renderNextImage()
   }
    
    private func renderNextImage(){
        if (self.currentIndex < scanSession.scannedItems.count){
            let scannedItem = scanSession.scannedItems[currentIndex]
            if let renderedImage = scannedItem.renderedImage{
                self.images.append(renderedImage)
                self.currentIndex = self.currentIndex + 1
                self.renderNextImage()
            } else {
                print("Rendering image \(self.currentIndex)")
                ScannedItemRenderer().render(scannedItem: scannedItem) { (image) in
                    if let image = image {
                        self.images.append(image)
                    }
                    self.currentIndex =  self.currentIndex + 1
                    self.renderNextImage()
                }
            }
        } else {
            print("Finished!")
            self.createPDFWith(images: self.images, inPath: self.outputPath)
        }
    }
    
    
}
