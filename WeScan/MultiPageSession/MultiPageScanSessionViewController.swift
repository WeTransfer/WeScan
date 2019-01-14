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
    
    lazy private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    init(scanSession:MultiPageScanSession){
        self.scanSession = scanSession
        super.init(nibName: nil, bundle: nil)
        setupPages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be called for this class")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Private
    
    private func setupPages(){
        self.scanSession.scannedItems.forEach { (scannedItem) in
            let vc = ScannedPageViewController(scannedItem: scannedItem)
            vc.view.isUserInteractionEnabled = false
            self.pages.append(vc)
        }
        self.gotoLastPage()
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
        
        // Page Control
        let pageControlConstraints = [self.pageControl.bottomAnchor.constraint(equalTo: self.view!.bottomAnchor, constant:0.0),
                                      self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)]
        self.view.addSubview(self.pageControl)
        NSLayoutConstraint.activate(pageControlConstraints)
        
        // Navigation
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        // Toolbar
        self.navigationController?.toolbar.isTranslucent = false
        let editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        let deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(handleTrash))
        let rotateIconImage = UIImage(named: "rotate", in: Bundle(for: MultiPageScanSessionViewController.self), compatibleWith: nil)
        let rotateItem = UIBarButtonItem(image: rotateIconImage, style: .plain, target: self, action: #selector(handleRotate))
        
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.toolbarItems = [editItem, flexibleItem, rotateItem, flexibleItem, deleteItem]
    }
    
    private func getCurrentViewController()->ScannedPageViewController{
        return self.pageController.viewControllers!.first! as! ScannedPageViewController
    }
    
    private func getCurrentPageIndex()->Int?{
        let currentViewController = self.getCurrentViewController()
        return self.pages.index(of:currentViewController)
    }
    
    private func getCurrentItem()->ScannedItem?{
        if let currentIndex = self.getCurrentPageIndex(){
            return self.scanSession.scannedItems[currentIndex]
        }
        return nil
    }
    
    private func updateTitle(index:Int){
        self.title = "\(index + 1) / \(self.pages.count)"
    }
    
    private func gotoLastPage(direction:UIPageViewController.NavigationDirection? = .forward){
        let lastIndex = self.pages.count - 1
        self.gotoPage(index: lastIndex, direction: direction)
    }
    
    private func gotoPage(index:Int, direction:UIPageViewController.NavigationDirection? = .forward){
        self.pageController.setViewControllers([self.pages[index]], direction: direction!, animated: true, completion: nil)
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = index
        self.updateTitle(index: index)
    }
    
    private func trashCurrentPage(){
        if let currentIndex = self.getCurrentPageIndex(){
            self.scanSession.remove(index: currentIndex)
            self.pages.remove(at: currentIndex)
            if (self.scanSession.scannedItems.count > 0){
                let previousIndex  = currentIndex - 1
                let newIndex = (previousIndex >= 0 ? previousIndex : 0)
                let direction:UIPageViewController.NavigationDirection = (newIndex == 0 ? .forward : .reverse)
                self.gotoPage(index: newIndex, direction: direction)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Button handlers
    
    @objc private func handleSave(){
        self.delegate?.multiPageScanSessionViewController(self, finished: self.scanSession)
    }
    
    @objc private func handleRotate(){
        if let currentItem = self.getCurrentItem(){
            currentItem.rotation -= 90.0
            self.getCurrentViewController().reRender(item: currentItem)
        }
    }
    
    @objc private func handleTrash(){
        let alertController = UIAlertController(title: "Confirm",
                                                message: "Are you sure you want to delete this page?",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.trashCurrentPage()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleEdit(){
        if let currentIndex = self.getCurrentPageIndex(){
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
    
    func editScanViewController(_ editScanViewController: EditScanViewController, finishedEditing item: ScannedItem) {
        self.dismiss(animated: true, completion: nil)
        let currentViewController = self.getCurrentViewController()
        currentViewController.reRender(item: item)
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
        
        if let index = index {
            self.updateTitle(index:index)
            self.pageControl.currentPage = index
        }
    }
    
    
}
