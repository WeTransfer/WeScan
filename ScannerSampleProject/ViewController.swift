//
//  ViewController.swift
//  ScannerSampleProject
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import Scanner

class ViewController: UIViewController {
    
    private lazy var scanButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Scan Now!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapScanButton(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 64.0 / 255.0, green: 159 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 20.0
        return button
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setups
    
    private func setupViews() {
        view.addSubview(scanButton)
    }
    
    private func setupConstraints() {
        let scanButtonConstraints = [
            view.bottomAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 40.0),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.heightAnchor.constraint(equalToConstant: 40.0),
            scanButton.widthAnchor.constraint(equalToConstant: 150.0)
        ]
        
        NSLayoutConstraint.activate(scanButtonConstraints)
    }
    
    // MARK: - Actions
    
    @objc func handleTapScanButton(_ sender: Any?) {
        let scannerVC = ImageScannerController()
        scannerVC.imageScannerDelegate = self
        present(scannerVC, animated: true, completion: nil)
    }
    
}

extension ViewController: ImageScannerControllerDelegate {
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
}
