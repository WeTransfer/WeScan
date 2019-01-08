//
//  ScannedPageViewController.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

class ScannedPageViewController: UIViewController {

    private var scannedItem:ScannedItem
    private var renderedImage:UIImage?
    private var renderedImageView:UIImageView!
    
    init(scannedItem:ScannedItem){
        self.scannedItem = scannedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.renderedImageView = UIImageView(image: nil)
        self.renderedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.renderedImageView.contentMode = .scaleAspectFit
        
        let constraints = [self.renderedImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
                           self.renderedImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
                           self.renderedImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
                           self.renderedImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)]
        self.view.addSubview(self.renderedImageView)
        NSLayoutConstraint.activate(constraints)
        
        self.render()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func reRender(item:ScannedItem){
        self.renderedImageView.image = nil
        self.scannedItem = item
        self.render()
    }
    
    private func render(){
        if (self.renderedImageView.image == nil){
            self.renderedImage = self.scannedItem.rednerQuadImage()
            self.renderedImageView.image = self.renderedImage
        }
    }
}
