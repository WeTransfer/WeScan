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
        case ready
        case executing
        case finished
    }
    
    let imageScannerResults: ImageScannerResults
    
    @objc private dynamic var state: OperationState
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    required init(withResults imageScannerResults: ImageScannerResults) {
        self.state = .ready
        self.imageScannerResults = imageScannerResults
        super.init()
    }
    
    override func start() {
        self.state = .executing
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
            try? self?.imageScannerResults.generateScannedImage(completion: {
                DispatchQueue.main.async {
                    completion()
                }
            })
        }
    }
    
    private func finish() {
        state = .finished
        completionBlock?()
    }
    
}
