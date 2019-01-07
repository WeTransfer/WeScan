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
        self.scanSession.scannedItems.forEach { (scannedItem) in
            let scannedPageViewController = ScannedPageViewController(scannedItem:scannedItem)
            self.pages.append(scannedPageViewController)
        }
        self.pageController.setViewControllers([self.pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews(){
        self.view.backgroundColor = UIColor.red
        let constraints = [self.pageController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
                           self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
                           self.pageController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
                           self.pageController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)]
        self.view.addSubview(self.pageController.view)
        NSLayoutConstraint.activate(constraints)
        /*
        quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            quadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]*/
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
