//
//  ScanGalleryViewController.swift
//  WeScan
//
//  Created by Bobo on 6/22/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

final class ScanGalleryViewController: UIPageViewController {
    
    var results: [ImageScannerResults]
    
    weak var scanGalleryDelegate: ImageScannerResultsDelegateProtocol?
    
    lazy private var doneBarButtonItem: UIBarButtonItem = {
        let title = NSLocalizedString("wescan.review.button.done", tableName: nil, bundle: Bundle(for: ScannerViewController.self), value: "Done", comment: "The right button of the ScannerViewController")
        let barButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.done, target: self, action: #selector(saveImageScannerController(_:)))
        return barButtonItem
    }()
    
    let deleteButton: UIButton = {
        // TODO: Use actual design
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deleteCurrentImage(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editButton: UIButton = {
        // TODO: Use actual design
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(editCurrentImage(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.purple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        view.addSubview(deleteButton)
        view.addSubview(editButton)
        setupConstraints()
        
        let viewController = ReviewViewController(results: result)
        setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
    }
    
    private func setupConstraints() {
        let deleteButtonConstraints = [
            deleteButton.heightAnchor.constraint(equalToConstant: 44.0),
            deleteButton.widthAnchor.constraint(lessThanOrEqualToConstant: 44.0),
            view.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 10.0),
            view.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 10.0)
        ]
        
        let editButtonConstraints = [
            editButton.heightAnchor.constraint(equalToConstant: 44.0),
            editButton.widthAnchor.constraint(lessThanOrEqualToConstant: 44.0),
            deleteButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 10.0),
            view.bottomAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 10.0)
        ]
        
        NSLayoutConstraint.activate(deleteButtonConstraints + editButtonConstraints)
    }
    
    // MARK: - Actions
    
    @objc private func deleteCurrentImage(_ sender: Any?) {
        guard let currentReviewViewController = viewControllers?.first as? ReviewViewController,
        let index = results.index(of: currentReviewViewController.results) else {
            return
        }
        
        results.remove(at: index)
        scanGalleryDelegate?.didUpdateResults(results: results)

        guard results.isEmpty == false else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        let viewController = ReviewViewController(results: results[max(index - 1, 0)])
        let direction = (index > 0) ? UIPageViewControllerNavigationDirection.reverse : UIPageViewControllerNavigationDirection.forward
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    @objc private func editCurrentImage(_ sender: Any?) {
        guard let currentReviewViewController = viewControllers?.first as? ReviewViewController else {
                return
        }

        let editViewController = EditScanViewController(result: currentReviewViewController.results)
        editViewController.delegate = self
        editViewController.modalTransitionStyle = .crossDissolve
        present(editViewController, animated: true, completion: nil)
    }
    
    @objc private func saveImageScannerController(_ sender: UIButton) {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFinishScanningWithResults: results)
        }
    }

}

extension ScanGalleryViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let reviewViewController = viewController as? ReviewViewController,
        let index = results.index(of: reviewViewController.results),
        index > 0 else {
            return nil
        }
        
        return ReviewViewController(results: results[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let reviewViewController = viewController as? ReviewViewController,
            let index = results.index(of: reviewViewController.results),
            index < results.count - 1 else {
                return nil
        }
        
        return ReviewViewController(results: results[index + 1])
    }
    
}

extension ScanGalleryViewController: ImageScannerResultsDelegateProtocol {
    
    func didUpdateResults(results: [ImageScannerResults]) {
        guard let currentReviewViewController = viewControllers?.first as? ReviewViewController else {
            return
        }
        
        currentReviewViewController.reloadImage()
    }
    
}
