//
//  ReviewImageViewController.swift
//  WeScanSampleProject
//
//  Created by Chawatvish Worrapoj on 8/1/2020
//  Copyright © 2020 WeTransfer. All rights reserved.
//

import UIKit
import AudioToolbox

final class ReviewImageViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    var image: UIImage?
    lazy var imageCheck: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_check")
        imageView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        imageView.contentMode = .scaleAspectFit
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        imageView.image = image
        imageView.addSubview(imageCheck)
        self.setupCheckMarkConstraints()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
    private func setupCheckMarkConstraints() {
        // imageCheck.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        imageCheck.translatesAutoresizingMaskIntoConstraints = false
        let centerVertically = NSLayoutConstraint(item: imageCheck,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0)
        let centerHorizontally = NSLayoutConstraint(item: imageCheck,
                                                    attribute: .centerY,
                                                    relatedBy: .equal,
                                                    toItem: imageView,
                                                    attribute: .centerY,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        let widthConstraint = NSLayoutConstraint(item: imageCheck,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: imageView,
                                                 attribute: .width,
                                                 multiplier: 0.2,
                                                 constant: 0)
        let heightConstraint = NSLayoutConstraint(item: imageCheck,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 0.2,
                                                  constant: 0)
        NSLayoutConstraint.activate([centerVertically, centerHorizontally, widthConstraint, heightConstraint])
        
        
    }

}




    
