//
//  ImageScanner.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 08/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public class ImageScanner:NSObject{
    
    private weak var baseViewController:UIViewController?
    
    public func startScanningFrom(baseViewController:UIViewController){
        let scanSession = MultiPageScanSession()
        let scanSessionViewController = MultiPageScanSessionViewController(scanSession: scanSession)
        scanSessionViewController.delegate = self
        baseViewController.present(scanSessionViewController, animated: true, completion: nil)
        
        
        /*
        self.baseViewController = baseViewController
        let scannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        baseViewController.present(scannerViewController, animated: true, completion: nil)
        */
    }
    
}

extension ImageScanner:MultiPageScanSessionViewControllerDelegate{
    
    func multiPageScanSessionViewController(_ multiPageScanSessionViewController: MultiPageScanSessionViewController, finished session: MultiPageScanSession) {
        
    }
    
}

extension ImageScanner:ScannerViewControllerDelegate{
    
    func scannerViewController(_ scannerViewController: ScannerViewController, reviewItems inSession: MultiPageScanSession) {
        
    }
    
    func scannerViewController(_ scannerViewController: ScannerViewController, didFail withError: Error) {
        // TODO: Present message to user
    }
    
    func scannerViewControllerDidCancel(_ scannerViewController: ScannerViewController) {
        self.baseViewController?.dismiss(animated: true, completion: nil)
    }
    
}
