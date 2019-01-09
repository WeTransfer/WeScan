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
    private var renderedImageView:UIImageView!
    private var activityIndicator:UIActivityIndicatorView!
    
    init(scannedItem:ScannedItem){
        self.scannedItem = scannedItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.render()
    }

    // MARK: - Private methods
    
    private func setupViews(){
        // Image View
        self.renderedImageView = UIImageView(image: nil)
        self.renderedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.renderedImageView.contentMode = .scaleAspectFit
        
        let constraints = [self.renderedImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
                           self.renderedImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
                           self.renderedImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
                           self.renderedImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)]
        self.view.addSubview(self.renderedImageView)
        NSLayoutConstraint.activate(constraints)
        
        // Spinner
        self.activityIndicator = UIActivityIndicatorView(style: .white)
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let activityIndicatorConstraints = [self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)]
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    // MARK: - Public methods
    
    public func reRender(item:ScannedItem){
        self.renderedImageView.image = nil
        self.scannedItem = item
        self.render()
    }
    
    public func render(){
        if (self.renderedImageView.image == nil){
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.scannedItem.renderQuadImage(completion: { (image) in
                self.renderedImageView.image = image
                self.activityIndicator.stopAnimating()
            })
        }
    }
}
