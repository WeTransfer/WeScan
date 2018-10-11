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
        imageView.image = results.last!.scannedImage
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var doneButton: UIBarButtonItem = {
        let title = "Next"
        let button = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(finishScan))
        //button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    private var frame: CGRect {
        return self.view.frame
    }
    
    private var addButton: UIButton!
    
    private let results: [ImageScannerResults]
    
    // MARK: - Life Cycle
    
    init(results: [ImageScannerResults]) {
        self.results = results
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.translatesAutoresizingMaskIntoConstraints = false
        
        createButton()
        setupViews()
        setupConstraints()
        
        title = NSLocalizedString("wescan.review.title", tableName: nil, bundle: Bundle(for: ReviewViewController.self), value: "Review", comment: "The review title of the ReviewController")
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: Setups
    
    private func createButton() {
        self.addButton = UIButton()
        self.addButton.tag = 5
        self.addButton.layer.cornerRadius = 0.5 * 50
        self.addButton.clipsToBounds = true
        self.addButton.setImage(UIImage(named: "add.png", in: Bundle(for: ReviewViewController.self), compatibleWith: nil), for: .normal)
        self.addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addButton.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.75)
    }
    
    private func setupViews() {
        self.view.addSubview(imageView)
        self.view.addSubview(addButton)
    }
    
    private func setupConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.bottomAnchor, constant: -40).isActive = true
        addButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        
    }
    
    // MARK: - Actions
    
    @objc private func finishScan() {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: results)
        }
    }
    
    @objc private func addButtonPressed() {
        let scanVc = ScannerViewController()
        scanVc.results = self.results
        
        navigationController?.pushViewController(scanVc, animated: true)
    }
    
}
