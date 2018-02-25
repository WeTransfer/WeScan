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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(handleTapNext(sender:)), for: .touchUpInside)
        return button
    }()

    private let image: UIImage
    private let quad: Quadrilateral
    
    private var quadViewWidthConstraint: NSLayoutConstraint?
    private var quadViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Life Cycle
    
    init(image: UIImage, quad: Quadrilateral) {
        self.image = image
        self.quad = quad
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        title = "Edit scan"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
    }
    
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quadViewWidthConstraint!,
            quadViewHeightConstraint!
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints)
    }
    
    // MARK - Actions
    
    @objc func handleTapNext(sender: UIButton) {
        guard let quad = quadView.quad,
            var ciImage = CIImage(image: image),
            var scaledQuad = quad.scale(quadView.bounds.size, image.size) else {
            // TODO: Handle Error
            return
        }
        
        let orientationTransform = ciImage.orientationTransform(forExifOrientation: 6)
        ciImage = ciImage.transformed(by: orientationTransform)
        
        scaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        scaledQuad.reorganize()
        
        let filteredImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: scaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: scaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: scaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: scaledQuad.topRight)
            ])
 
        var uiImage = UIImage(ciImage: filteredImage, scale: 1.0, orientation: .up)
        uiImage = uiImage.imageWithPortraitOrientation()

        let reviewViewController = ReviewViewController(image: uiImage)
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    private func displayQuad() {
        let imageSize = image.size
        let imageFrame = CGRect(x: quadView.frame.origin.x, y: quadView.frame.origin.y, width: quadViewWidthConstraint!.constant, height: quadViewHeightConstraint!.constant)
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad)
    }
    
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        quadViewWidthConstraint?.constant = frame.size.width
        quadViewHeightConstraint?.constant = frame.size.height
    }

}
