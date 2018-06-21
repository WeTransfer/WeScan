//
//  ScanOperation.swift
//  WeScan
//
//  Created by Boris Emorine on 6/21/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

final class ScanOperation: Operation {
    
    @objc enum OperationState: Int {
        case Ready
        case Executing
        case Finished
    }
    
    let imageScannerResults: ImageScannerResults
    
    @objc private dynamic var state: OperationState
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return state == .Ready
    }
    
    override var isExecuting: Bool {
        return state == .Executing
    }
    
    override var isFinished: Bool {
        return state == .Finished
    }
    
    required init(withResults imageScannerResults: ImageScannerResults) {
        self.state = .Ready
        self.imageScannerResults = imageScannerResults
        super.init()
    }
    
    override func start() {
        self.state = .Executing
        guard isCancelled == false else {
            finish()
            return
        }
        
        execute { [weak self] in
            self?.finish()
        }
    }
    
    private func execute(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            try? self?.imageScannerResults.generateScannedImage()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func finish() {
        state = .Finished
        completionBlock?()
    }
    
}
