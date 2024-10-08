//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

//
//  EditScanViewController.swift
//  ReInventNotes
//
//  Created by MacMini2 on 18/01/24.
//

import AVFoundation
import UIKit

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewControllerCustom: UIViewController {
    var photoPreviewVC: PhotoSlideVC?
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
    var homeVC: HomeViewController?
    var existingFileName: String = ""
    var isDirectEdit: Bool = false
    private lazy var quadView: QuadrilateralViewCustom = {
        let quadView = QuadrilateralViewCustom()
        quadView.editable = true
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    private lazy var customBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(pushReviewController), for: .touchUpInside)
        button.tintColor = navigationController?.navigationBar.tintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var resizeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_detectedSize"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(resizeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    /// The image the quadrilateral was detected on.
    private let image: UIImage

    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    private var quad: QuadrilateralCustom

    private var zoomGestureController: ZoomGestureController!

    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    private var isResizing: Bool = false
    private var bottomToolbarHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle

    init(image: UIImage, quad: QuadrilateralCustom?, rotateImage: Bool = true) {
        self.image = rotateImage ? image.applyingPortraitOrientation() : image
        self.quad = quad ?? EditScanViewControllerCustom.defaultQuad(forImage: image)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupConstraints()
        title = NSLocalizedString("wescan.edit.title",
                                   tableName: nil,
                                   bundle: Bundle(for: EditScanViewControllerCustom.self),
                                   value: "Edit Scan",
                                   comment: "The title of the EditScanViewController"
        )
        setupZoomGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        if !isResizing {
            displayQuad()
        }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
        if isDirectEdit {
            if isMovingFromParent {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }

    // MARK: - Setups

    private func setupNavigation() {
        if isDirectEdit {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationController?.navigationBar.barTintColor = .white
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            navigationController?.setToolbarHidden(true, animated: false)
        }

        let saveButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(actionSaveCurrentImage(_:)))
        navigationItem.rightBarButtonItem = saveButtonItem
        
        if let navigationController = navigationController {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController.navigationBar.titleTextAttributes = attributes
        }
    }

    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(quadView)
        view.addSubview(customBottomView)
        
        customBottomView.addSubview(cancelButton)
        customBottomView.addSubview(resizeButton)
        customBottomView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        // Image view constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 100),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
        
        // Quad view constraints
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([
            quadView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ])
        
        // Custom bottom view constraints
        NSLayoutConstraint.activate([
            customBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customBottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customBottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            customBottomView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Button constraints
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: customBottomView.leadingAnchor, constant: 15.0),
            cancelButton.centerYAnchor.constraint(equalTo: customBottomView.centerYAnchor),
            resizeButton.centerXAnchor.constraint(equalTo: customBottomView.centerXAnchor),
            resizeButton.centerYAnchor.constraint(equalTo: customBottomView.centerYAnchor),
            resizeButton.widthAnchor.constraint(equalToConstant: 30),
            resizeButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.trailingAnchor.constraint(equalTo: customBottomView.trailingAnchor, constant: -15.0),
            nextButton.centerYAnchor.constraint(equalTo: customBottomView.centerYAnchor),
        ])
    }

    private func setupZoomGesture() {
        zoomGestureController = ZoomGestureController(image: image, quadView: quadView)
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        quadView.addGestureRecognizer(touchDown)
    }

    @objc func actionSaveCurrentImage(_ sender: Any) {
        guard let quad = quadView.quad,
              let ciImage = CIImage(image: image) else {
            if let imageScannerController = navigationController as? ImageScannerControllerCustom {
                let error = ImageScannerControllerError.ciImageCreation
                imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
            }
            return
        }
        let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
        let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
        let scaledQuad = quad.scale(quadView.bounds.size, image.size)
        self.quad = scaledQuad

        // Cropped Image
        var cartesianScaledQuad = scaledQuad.toCartesian(withHeight: image.size.height)
        cartesianScaledQuad.reorganize()

        let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
            "inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
            "inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
            "inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
        ])

        guard let context = CIContext(options: nil),
              let croppedCGImage = context.createCGImage(filteredImage, from: filteredImage.extent) else {
            return
        }

        let newImage = UIImage(cgImage: croppedCGImage)
        saveImage(newImage)
    }

    private func saveImage(_ newImage: UIImage) {
        let compressedData = newImage.jpegData(compressionQuality: 0.8)
        let filename = existingFileName.isEmpty ? UUID().uuidString : existingFileName
        // Save logic goes here...
    }

    // MARK: - Button Actions
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func pushReviewController() {
        // Implement your push review controller logic here
    }

    @objc func resizeButtonTapped() {
        // Implement your resize logic here
    }
    
    // MARK: - Adjust Quadrilateral
    private func adjustQuadViewConstraints() {
        let rect = quad.rect()
        quadViewWidthConstraint.constant = rect.width
        quadViewHeightConstraint.constant = rect.height
    }

    private func displayQuad() {
        quadView.quad = quad
    }

    private static func defaultQuad(forImage image: UIImage) -> QuadrilateralCustom {
        let width = image.size.width
        let height = image.size.height
        return QuadrilateralCustom(topLeft: CGPoint(x: 0, y: 0),
                                   topRight: CGPoint(x: width, y: 0),
                                   bottomLeft: CGPoint(x: 0, y: height),
                                   bottomRight: CGPoint(x: width, y: height))
    }
}

