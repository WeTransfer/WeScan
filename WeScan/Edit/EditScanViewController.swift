//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewController: UIViewController {
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = result.originalImage
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
    
    lazy private var cancelButton: UIButton = {
        let title = NSLocalizedString("wescan.edit.button.cancel", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Cancel", comment: "A generic cancel button")
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(cancel(sender:)), for: .touchUpInside)
        button.tintColor = navigationController?.navigationBar.tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var saveButton: UIButton = {
        let title = NSLocalizedString("wescan.edit.button.save", tableName: nil, bundle: Bundle(for: EditScanViewController.self), value: "Save", comment: "A generic save button")
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(save(sender:)), for: .touchUpInside)
        button.tintColor = navigationController?.navigationBar.tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let result: ImageScannerResults
    
    weak var delegate: ImageScannerResultsDelegateProtocol?
    
    private var zoomGestureController: ZoomGestureController!
    
    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(result: ImageScannerResults) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        zoomGestureController = ZoomGestureController(image: result.originalImage, quadView: quadView)
        
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.cancelsTouchesInView = false
        touchDown.minimumPressDuration = 0
        touchDown.delegate = self
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
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
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
        
        let cancelButtonConstraints = [
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            view.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10.0)
        ]
        
        let saveButtonConstraints = [
            view.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 10.0),
            view.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 10.0)
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints + imageViewConstraints + cancelButtonConstraints + saveButtonConstraints)
    }
    
    // MARK: - Actions
    
    @objc private func cancel(sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save(sender: Any?) {
        guard let quad = quadView.quad else {
            return
        }
        let scaledQuad = quad.scale(quadView.bounds.size, result.originalImage.size)
        result.detectedRectangle = scaledQuad
        
        try? result.generateScannedImage { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.delegate?.didUpdateResults(results: [strongSelf.result])
            strongSelf.dismiss(animated: true, completion: nil)
        }
        
        // TODO: Handle Error
    }
    
    private func displayQuad() {
        let imageSize = result.originalImage.size
        let imageFrame = CGRect(x: quadView.frame.origin.x, y: quadView.frame.origin.y, width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant)
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = result.detectedRectangle.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }
    
    /// The quadView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints to make sure that the quadView is on top of the displayed image.
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: result.originalImage.size, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }

}

extension EditScanViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view != cancelButton && touch.view != saveButton else {
            return false
        }
        return true
    }
    
}
