//
//  ReviewViewController.swift
//  Scanner
//
//  Created by Boris Emorine on 2/25/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

final class ReviewViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = results.scannedImage
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Done", for: .normal)
        button.setTitleColor(navigationController?.navigationBar.tintColor, for: .normal)
        button.addTarget(self, action: #selector(handleTapDone(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let results: ImageScannerResults
    
    // MARK: - Life Cycle
    
    init(results: ImageScannerResults) {
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
        
        title = "Review"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    // MARK: Setups
    
    private func setupViews() {
        view.addSubview(imageView)
    }
    
    private func setupConstraints() {
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    // MARK - Actions
    
    @objc func handleTapDone(sender: UIButton) {
        if let navigationController = navigationController as? ImageScannerController {
            navigationController.imageScannerDelegate?.imageScannerController(navigationController, didFinishScanningWithResults: results)
        }
    }

}
