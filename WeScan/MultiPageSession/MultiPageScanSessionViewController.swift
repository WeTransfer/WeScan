//
//  MultiPageScanSessionViewController.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

class MultiPageScanSessionViewController: UIViewController {

    private var scanSession:MultiPageScanSession
    private var pages:Array<ScannedPageViewController> = []
    
    lazy private var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        return pageController
    }()
    
    init(scanSession:MultiPageScanSession){
        self.scanSession = scanSession
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanSession.scannedItems.forEach { (scannedItem) in
            let scannedPageViewController = ScannedPageViewController(scannedItem:scannedItem)
            self.pages.append(scannedPageViewController)
        }
        self.setupViews()
    }
    
    private func setupViews(){
        self.view.backgroundColor = UIColor.red
        
        self.addChild(self.pageController)
    }

}

extension MultiPageScanSessionViewController:UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: (viewController as! ScannedPageViewController)){
            let previousIndex = index - 1
            if (previousIndex >= 0){
                return self.pages[previousIndex]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: (viewController as! ScannedPageViewController)){
            let nextIndex = index + 1
            if (nextIndex < (pages.count - 1)){
                return self.pages[nextIndex]
            }
        }
        return nil
    }
    
}
