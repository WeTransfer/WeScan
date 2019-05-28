//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

protocol EditScanViewControllerDelegate:NSObjectProtocol {
    func editScanViewControllerDidCancel(_ editScanViewController:EditScanViewController)
    func editScanViewController(_ editScanViewController:EditScanViewController, finishedEditing item:ScannedItem)
}

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewController: UIViewController {
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = image
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    lazy private var doneButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.edit.button.done", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Done", comment: "A generic done button")
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(handleDone))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()

    /// The image the quadrilateral was detected on.
    private let image: UIImage
    
    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    private var quad: Quadrilateral
    
    /// The object that acts as the delegate of the `EditScanViewController`.
    weak public var delegate: EditScanViewControllerDelegate?
    
    private var scannedItem:ScannedItem
    
    private var zoomGestureController: ZoomGestureController!
    
    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(scannedItem:ScannedItem) {
        self.scannedItem = scannedItem
        self.image = scannedItem.originalImage.applyingPortraitOrientation()
        
        let quad = scannedItem.quad ?? EditScanViewController.defaultQuad(forImage: scannedItem.originalImage)
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
        title = NSLocalizedString("wescan.edit.title", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Edit Scan", comment: "The title of the EditScanViewController")
        navigationItem.rightBarButtonItem = doneButton
        
        zoomGestureController = ZoomGestureController(image: image, quadView: quadView)
        
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        view.addGestureRecognizer(touchDown)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
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

        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints + imageViewConstraints)
    }
    
    // MARK: - Actions
    
    @objc func handleDone() {
        
        guard let quad = quadView.quad else {
            // TODO: Return error
            return
        }
        
        let scaledQuad = quad.scale(quadView.bounds.size, image.size)
        self.quad = scaledQuad
        
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()
        
        scannedItem.quad = scaledQuad
        
        self.delegate?.editScanViewController(self, finishedEditing: scannedItem)
    }

    private func displayQuad() {
        let imageSize = image.size
        let imageFrame = CGRect(origin: quadView.frame.origin, size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant))
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }
    
    /// The quadView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints to make sure that the quadView is on top of the displayed image.
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
    /// Generates a `Quadrilateral` object that's centered and one third of the size of the passed in image.
    public static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
        let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
        let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        
        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return quad
    }

}
