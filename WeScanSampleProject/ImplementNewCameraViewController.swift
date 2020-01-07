//
//  ImplementNewCameraViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 7/1/2563 BE.
//  Copyright © 2563 WeTransfer. All rights reserved.
//

import UIKit
import WeScan

class ImplementNewCameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    var controller: CameraScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        controller = CameraScannerViewController()
        controller.view.frame = cameraView.bounds
        controller.willMove(toParent: self)
        cameraView.addSubview(controller.view)
        self.addChild(controller)
        controller.didMove(toParent: self)
        controller.delegate = self
    }
    
    @IBAction func flashTapped(_ sender: UIButton) {
        controller.toggleFlash()
    }
    
    @IBAction func captureTapped(_ sender: UIButton) {
        controller.capture()
    }

}

extension ImplementNewCameraViewController: CameraScannerViewOutputDelegate {
    func captureImageFailWithError(error: Error) {
        print(error)
    }
    
    func captureImageSuccess(image: UIImage, withQuad quad: Quadrilateral?) {
        let editVC = EditImageViewController(image: image, quad: quad)
        navigationController?.pushViewController(editVC, animated: false)
    }
}
