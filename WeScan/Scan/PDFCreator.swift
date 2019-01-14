//
//  ImageToPDF.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 08/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public typealias PDFCreatorProgressBlock = ((_ fractionCompleted:Double) -> Void)
public typealias PDFCreatorCompletionBlock = ((_ error:Error?) -> Void)

public class PDFCreator {
    
    var currentIndex = 0
    var images = Array<UIImage>()
    
    private let scanSession:MultiPageScanSession
    private let outputPath:String
    private let outputResolution:CGFloat?
    
    private var completion:PDFCreatorCompletionBlock!
    private var progress:PDFCreatorProgressBlock!
    
    public init(scanSession:MultiPageScanSession, in path:String, with outputResolution:CGFloat? = 0){
        self.scanSession = scanSession
        self.outputPath = path
        self.outputResolution = outputResolution
    }
    
    // MARK: Public methods
    
    public func createPDF(completion:@escaping PDFCreatorCompletionBlock, progress:@escaping PDFCreatorProgressBlock){
        self.completion = completion
        self.progress = progress

        self.currentIndex = 0
        self.renderNextImage()
    }
    
    // MARK: Private methods
    
    private func renderNextImage(){
        if (self.currentIndex < scanSession.scannedItems.count){
            let scannedItem = scanSession.scannedItems[currentIndex]
            if let renderedImage = scannedItem.renderedImage{
                self.images.append(renderedImage)
                self.currentIndex = self.currentIndex + 1
                self.progress(Double(self.currentIndex)/Double(self.scanSession.scannedItems.count))
                self.renderNextImage()
            } else {
                print("Rendering image \(self.currentIndex)")
                ScannedItemRenderer().render(scannedItem: scannedItem) { (image) in
                    if let image = image {
                        self.images.append(image)
                    }
                    self.currentIndex =  self.currentIndex + 1
                    self.progress(Double(self.currentIndex)/Double(self.scanSession.scannedItems.count))
                    self.renderNextImage()
                }
            }
        } else {
            print("Finished!")
            self.makePDFFromImages()
        }
    }
    
    private func makePDFFromImages(){
        
        UIGraphicsBeginPDFContextToFile(self.outputPath, CGRect.zero, nil);
        
        self.images.forEach { (image) in
            var outputImage:UIImage! = nil
            if let outputResolution = self.outputResolution,
                outputResolution > 0.0,
                let reducedImage = image.resizeImage(newWidth: outputResolution){
                outputImage = reducedImage
            } else {
                outputImage = image
            }
            UIGraphicsBeginPDFPageWithInfo(CGRect(x:0, y:0, width:outputImage.size.width, height:outputImage.size.height), nil);
            outputImage.draw(in: CGRect(x: 0, y: 0, width: outputImage.size.width, height: outputImage.size.height))
        }
        UIGraphicsEndPDFContext();
    }
    
    
}
