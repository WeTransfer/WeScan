//
//  EditScanViewController.swift
//  Scanner
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

class EditScanViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = image
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        return activityIndicator
    }()

    
    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    private let image: UIImage
    
    // MARK: - Life Cycle
    
    init(image: UIImage) {
        self.image = image
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        displayQuad()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
        imageView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quadView.heightAnchor.constraint(equalTo: view.heightAnchor),
            quadView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints)
        
        let activityIndicatorConstraints = [
            imageView.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(activityIndicatorConstraints)
    }
    
    private func displayQuad() {
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            DispatchQueue.main.async { [weak self] in

                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
