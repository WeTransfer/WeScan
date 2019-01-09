//
//  MultiPageScanSessionViewController.swift
//  WeScan
//
//  Created by Enrique Rodriguez on 07/01/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import UIKit

protocol MultiPageScanSessionViewControllerDelegate:NSObjectProtocol {
    func multiPageScanSessionViewController(_ multiPageScanSessionViewController:MultiPageScanSessionViewController, finished session:MultiPageScanSession)
}

class MultiPageScanSessionViewController: UIViewController {

    private var scanSession:MultiPageScanSession
    private var pages:Array<ScannedPageViewController> = []
    
    weak public var delegate:MultiPageScanSessionViewControllerDelegate?
    
    lazy private var saveButton: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.edit.button.save", tableName: nil, bundle: Bundle(for: MultiPageScanSessionViewController.self), value: "Save", comment: "Save button")
        let button = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(handleSave))
        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    lazy private var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        return pageController
    }()
    
    init(scanSession:MultiPageScanSession){
        self.scanSession = scanSession
        super.init(nibName: nil, bundle: nil)
        self.scanSession.scannedItems.forEach { (scannedItem) in
            let vc = ScannedPageViewController(scannedItem: scannedItem)
            vc.view.isUserInteractionEnabled = false
            self.pages.append(vc)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    private func setupViews(){
        // Page Controller
        let constraints = [self.pageController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
                           self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
                           self.pageController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
                           self.pageController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)]
        self.view.addSubview(self.pageController.view)
        NSLayoutConstraint.activate(constraints)
        self.addChild(self.pageController)
        
        // Navigation
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        // Toolbar
        self.navigationController?.toolbar.isTranslucent = false
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleTrash))
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.toolbarItems = [editItem, flexibleItem, deleteItem]
    }
    
    private func getCurrentViewController()->ScannedPageViewController{
        return self.pageController.viewControllers!.first! as! ScannedPageViewController
    }
    
    @objc private func handleSave(){
        self.delegate?.multiPageScanSessionViewController(self, finished: self.scanSession)
    }
    
    @objc private func handleTrash(){
        
    }
    
    @objc private func handleEdit(){
        let currentViewController = self.getCurrentViewController()
        if let currentIndex = self.pages.index(of:currentViewController){
            let currentItem = self.scanSession.scannedItems[currentIndex]
            
            let editViewController = EditScanViewController(scannedItem: currentItem)
            editViewController.delegate = self
            let navController = UINavigationController(rootViewController: editViewController)
            self.present(navController, animated: true, completion: nil)
        } else {
            fatalError("Current viewcontroller cannot be found")
        }
    }

}

extension MultiPageScanSessionViewController:EditScanViewControllerDelegate {

    func editScanViewControllerDidCancel(_ editScanViewController: EditScanViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func editScanViewController(_ editScanViewController: EditScanViewController, finishedEditing oldItem: ScannedItem, newItem: ScannedItem) {
        self.dismiss(animated: true, completion: nil)
        let currentViewController = self.getCurrentViewController()
        self.scanSession.replace(item: oldItem, with: newItem)
        currentViewController.reRender(item: newItem)
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
            if (nextIndex < pages.count){
                return self.pages[nextIndex]
            }
        }
        return nil
    }
    
}

extension MultiPageScanSessionViewController:UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        let currentViewController = self.getCurrentViewController()
        let index = self.pages.index(of:currentViewController)
        
        self.title = "\(index! + 1) / \(self.pages.count)"
    }
    
    
}
