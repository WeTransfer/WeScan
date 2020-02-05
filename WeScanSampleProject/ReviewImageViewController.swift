//
//  ReviewImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2563 BE.
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import UIKit

final class ReviewImageViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        imageView.image = image
    }
}
