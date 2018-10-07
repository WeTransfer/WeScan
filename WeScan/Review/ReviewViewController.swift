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
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = results.scannedImage
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var doneButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.review.button.done", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Done", comment: "A generic done button")
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(finishScan))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()

    lazy private var editEdgesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.blue
        button.setTitle(NSLocalizedString("Edit Edges", comment: ""), for: .normal)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.zillyFont(size: .size19, weight: ZLFontWeight.bold)
        return button
    }()

    lazy private var editColorsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Edit Colors", comment: ""), for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.blue
        button.titleLabel?.font = UIFont.zillyFont(size: .size19, weight: ZLFontWeight.bold)
        return button
    }()

    private let results: ImageScannerResults
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults, quad: Quadrilateral) {
        self.results = results
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        
        title = NSLocalizedString("wescan.review.title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Review", comment: "The review title of the ReviewController")
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: Setups
    
    private func setupViews() {
        view.addSubview(imageView)
        view.insertSubview(editColorsButton, aboveSubview: imageView)
        view.insertSubview(editEdgesButton, aboveSubview: imageView)
    }
    
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]

        let editColorsButtonConstraints = [
            editColorsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            editColorsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editColorsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editColorsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editColorsButton.heightAnchor.constraint(equalToConstant: 65.0)
        ]

        let editEdgesButtonConstraints = [
            editEdgesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65.0),
            editEdgesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editEdgesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editEdgesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editEdgesButton.heightAnchor.constraint(equalToConstant: 65.0)
        ]

        NSLayoutConstraint.activate(editColorsButtonConstraints)
        NSLayoutConstraint.activate(editEdgesButtonConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    // MARK: - Actions
    
    @objc private func finishScan() {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: results)
        }
    }

}
