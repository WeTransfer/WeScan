//
//  EditImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2020
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import UIKit
import WeScan

final class EditImageViewController: UIViewController {
    
    @IBOutlet private weak var editImageView: UIView!
    var captureImage: UIImage!
    var quad: Quadrilateral?
    var controller: WeScan.EditImageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let strokeColor = UIColor(red: (69.0 / 255.0),
                                  green: (194.0 / 255.0),
                                  blue: (177.0 / 255.0),
                                  alpha: 1.0).cgColor
        controller = WeScan.EditImageViewController(image: captureImage,
                                                    quad: quad,
                                                    strokeColor: strokeColor)
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
    
    @IBAction func rotateTapped(_ sender: UIButton!) {
        controller.rotateImage()
    }
}

extension EditImageViewController: EditImageViewDelegate {
    func cropped(image: UIImage) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ReviewImageView")
        guard let controller = controller as? ReviewImageViewController else { return }
        controller.modalPresentationStyle = .fullScreen
        controller.image = image
        navigationController?.pushViewController(controller, animated: false)
    }
}
