//
//  ImplementEditImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2563 BE.
//  Copyright © 2563 WeTransfer. All rights reserved.
//

import UIKit
import WeScan

class ImplementEditImageViewController: UIViewController {
    
    @IBOutlet weak var editImageView: UIView!
    var captureImage: UIImage!
    var quad: Quadrilateral?
    var controller: EditImageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        controller = EditImageViewController(image: captureImage, quad: quad)
        controller.view.frame = editImageView.bounds
        controller.willMove(toParent: self)
        editImageView.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        controller.delegate = self
    }
    
    @IBAction func cropTapped(_ sender: UIButton!) {
        controller.cropImage()
    }
}

extension ImplementEditImageViewController: EditImageViewDelegate {
    func cropped(image: UIImage?) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewImageView") as? ImplementReviewImageViewController else { return }
        controller.modalPresentationStyle = .fullScreen
        controller.image = image
        navigationController?.pushViewController(controller, animated: false)
    }
}
