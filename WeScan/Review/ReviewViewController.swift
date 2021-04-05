//
//  ReviewViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

/// The `ReviewViewController` offers an interface to review the image after it has been cropped and deskwed according to the passed in quadrilateral.
final class ReviewViewController: UIViewController {
    
    private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
    private var isCurrentlyDisplayingEnhancedImage = false
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = results.croppedScan.image
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var rotateButton: UIBarButtonItem = {
        let image = UIImage(systemName: "rotate.right", named: "rotate", in: Bundle(for: ScannerViewController.self), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rotateImage))
        button.tintColor = .white
        return button
    }()
    
    private lazy var doneButton: UIBarButtonItem = {
        let title = languageLocalization["done"] ?? NSLocalizedString("wescan.review.done", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Done", comment: "The done button of the ReviewController")
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(finishScan))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    private let results: ImageScannerResults
    
    private let languageLocalization: [String:String]
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults, languageLocalization: [String:String]) {
        self.results = results
        self.languageLocalization = languageLocalization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupToolbar()
        setupConstraints()
        
        title = languageLocalization["review"] ?? NSLocalizedString("wescan.review.title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Review", comment: "The review title of the ReviewController")
        navigationItem.rightBarButtonItem = doneButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    // MARK: Setups
    
    private func setupViews() {
        view.addSubview(imageView)
    }
    
    private func setupToolbar() {
        navigationController?.toolbar.barStyle = .blackTranslucent
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [flexibleSpace, rotateButton, fixedSpace]
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        var imageViewConstraints: [NSLayoutConstraint] = []
        if #available(iOS 11.0, *) {
            imageViewConstraints = [
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor),
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.trailingAnchor),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor),
                view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.leadingAnchor)
            ]
        } else {
            imageViewConstraints = [
                view.topAnchor.constraint(equalTo: imageView.topAnchor),
                view.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
            ]
        }
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    // MARK: - Actions
    
    @objc private func reloadImage() {
        imageView.image = results.croppedScan.image.rotated(by: rotationAngle) ?? results.croppedScan.image
    }
    
    @objc func rotateImage() {
        rotationAngle.value += 90
        
        if rotationAngle.value == 360 {
            rotationAngle.value = 0
        }
        
        reloadImage()
    }
    
    @objc private func finishScan() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        
        var newResults = results
        newResults.croppedScan.rotate(by: rotationAngle)
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: newResults)
    }

}
