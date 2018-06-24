//
//  ScanGalleryViewController.swift
//  WeScan
//
//  Created by Bobo on 6/22/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit

protocol ScanGalleryDelegateProtocol: NSObjectProtocol {
    
    func didUpdateResults(results: [ImageScannerResults])
    
}

final class ScanGalleryViewController: UIPageViewController {
    
    var results: [ImageScannerResults]
    
    weak var scanGalleryDelegate: ScanGalleryDelegateProtocol?
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(deleteCurrentImage(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.green
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
        
        view.addSubview(deleteButton)
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
        
        NSLayoutConstraint.activate(deleteButtonConstraints)
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
