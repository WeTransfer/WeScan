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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let scannerVC = ImageScannerController()
        present(scannerVC, animated: true, completion: nil)
    }
    
}
