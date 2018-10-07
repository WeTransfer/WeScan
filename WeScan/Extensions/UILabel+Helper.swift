//
//  UILabel+Helper.swift
//  WeScan
//
//  Created by Alejandro Reyes on 10/7/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addTextShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.masksToBounds = false
    }
}
