//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Alejandro Reyes on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import UIKit

final class EditColorsViewController : UIViewController {

    @IBOutlet private var slider: UISlider!
    @IBOutlet private var grayOptionView: UIView!
    @IBOutlet private var colorOptionView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var sliderView: UIView!

    private var results: ImageScannerResults
    private lazy var previousColoredImage: UIImage = results.scannedImage

    enum ColorOption {
        case gray, color
    }
    private var currentMode: ColorOption = .color { didSet { updateSelectedMode() } }
    var didFinishEditingImageHandler: ((ImageScannerResults) -> ())?

    // MARK: Lifecycle
    init(results: ImageScannerResults) {
        self.results = results
        let bundle = Bundle(identifier: "WeTransfer.WeScan")
        super.init(nibName: "EditColorsViewController", bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        grayOptionView.layer.borderWidth = 4.0
        colorOptionView.layer.borderWidth = 4.0
        title = NSLocalizedString("Adjust Contrast", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        imageView.image = results.scannedImage
        updateSelectedMode()
    }

    // MARK: Convenience
    private func updateSelectedMode() {
        if currentMode == .color {
            colorOptionView.layer.borderColor = UIColor(red: 24/255.0, green: 172/255.0, blue: 248/255.0, alpha: 1).cgColor
            grayOptionView.layer.borderColor = UIColor.clear.cgColor
        } else {
            colorOptionView.layer.borderColor = UIColor.clear.cgColor
            grayOptionView.layer.borderColor = UIColor(red: 24/255.0, green: 172/255.0, blue: 248/255.0, alpha: 1).cgColor
        }
        view.layoutIfNeeded()
    }

    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    // MARK: Actionns
    @IBAction func didTapColorOptionView(_ sender: UIButton) {
        guard currentMode != .color else { return }
        imageView.image = applyImageContrast(contrastValue: CGFloat(slider.value), with: previousColoredImage)
        currentMode = .color
        generateHapticFeedback()
    }
    
    @IBAction func didTapGrayOptionView(_ sender: UIButton) {
        guard currentMode != .gray else { return }
        previousColoredImage = imageView.image!
        imageView.image = applyImageContrast(contrastValue: CGFloat(slider.value), with: results.scannedImage.noir)
        currentMode = .gray
        generateHapticFeedback()
    }

    @objc private func donePressed() {
        results.scannedImage = imageView.image!
        didFinishEditingImageHandler?(results)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sliderDidChange(_ sender: UISlider) {
        imageView.image = applyImageContrast(contrastValue: CGFloat(sender.value))
    }

    func applyImageContrast(contrastValue: CGFloat, with newImage: UIImage? = nil) -> UIImage {
        let defaultCGImage = currentMode == .color ? self.results.scannedImage.cgImage! : self.results.scannedImage.noir!.cgImage!
        let context = CIContext(options: nil)
        let contrastFilter = CIFilter(name: "CIColorControls")!
        contrastFilter.setValue(CIImage(cgImage: newImage?.cgImage ?? defaultCGImage), forKey: "inputImage")
        contrastFilter.setValue(contrastValue, forKey: "inputContrast")
        let outputImage = contrastFilter.outputImage!
        let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: cgImage!)
        return newUIImage
    }
}
