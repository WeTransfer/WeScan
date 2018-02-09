//
//  RectangleFeaturesFunnel.swift
//  Scanner
//
//  Created by Boris Emorine on 2/9/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import Foundation
import AVFoundation

final class RectangleFeaturesFunnel {
    
    class RectangleMatch {
        let rectangleFeature: CIRectangleFeature
        var matchingScore = 0
        
        init(rectangleFeature: CIRectangleFeature) {
            self.rectangleFeature = rectangleFeature
        }
        
        let treshold: CGFloat = 50.0
        
        func matches(_ rectangle: CIRectangleFeature) -> Bool {
            return rectangleFeature.isWithin(treshold, ofRectangleFeature: rectangle)
        }
    }
    
    weak var delegate: RectangleDetectionDelegateProtocol?
    
    private(set) var isOpen = false
    
    private var rectanglesQueue = [RectangleMatch]()
    
    private let maxNumberOfRectangles = 5

    func add(_ rectangleFeature: CIRectangleFeature) {
        let rectangleMatch = RectangleMatch(rectangleFeature: rectangleFeature)

        rectanglesQueue.append(rectangleMatch)
        
        if rectanglesQueue.count > maxNumberOfRectangles {
            rectanglesQueue.removeFirst()
        }
        
        updateRectangleMatches()
        
        
    }
    
    func open() {
        
    }
    
    func close() {
        
    }
    
    private func updateRectangleMatches() {
        rectanglesQueue = rectanglesQueue.map { (rectange) -> RectangleMatch in
            rectange.matchingScore = 0
            return rectange
        }
        
        for (i, currentRect) in rectanglesQueue.enumerated() {
            for (j, rect) in rectanglesQueue.enumerated() {
                if j > i  && currentRect.matches(rect.rectangleFeature) {
                    currentRect.matchingScore += 1
                }
            }
        }
    }
    
}
