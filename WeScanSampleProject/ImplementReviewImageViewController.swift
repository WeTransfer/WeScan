//
//  ImplementReviewImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2563 BE.
//  Copyright © 2563 WeTransfer. All rights reserved.
//

import UIKit

class ImplementReviewImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        imageView.image = image
    }
}
