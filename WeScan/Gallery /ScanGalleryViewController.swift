//
//  ScanGalleryViewController.swift
//  WeScan
//
//  Created by Bobo on 6/22/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

class ScanGalleryViewController: UIPageViewController {
    
    let results: [ImageScannerResults]
    
    init(with results: [ImageScannerResults]) {
        self.results = results
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let result = results.first else {
            fatalError("This ViewController should be initialized with at least one ImageScannerResults")
        }
        
        dataSource = self
        
        let viewController = ReviewViewController(results: result)
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }

}

extension ScanGalleryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ReviewViewController,
        let index = results.index(of: viewController.results),
        index > 0 else {
            return nil
        }
        
        return ReviewViewController(results: results[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ReviewViewController,
            let index = results.index(of: viewController.results),
            index < results.count - 1 else {
                return nil
        }
        
        return ReviewViewController(results: results[index + 1])
    }
    
}
