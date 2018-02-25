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
    
    class RectangleMatch: NSObject {
        let rectangleFeature: CIRectangleFeature
        var matchingScore = 0

        init(rectangleFeature: CIRectangleFeature) {
            self.rectangleFeature = rectangleFeature
        }
        
        override var description : String {
            return "Matching score: \(matchingScore) - Rectangle: \(rectangleFeature)"
        }
        
        func matches(_ rectangle: CIRectangleFeature, withThreshold threshold: CGFloat) -> Bool {
            return rectangleFeature.isWithin(threshold, ofRectangleFeature: rectangle)
        }
    }
    
    private var rectanglesQueue = [RectangleMatch]()
    
    let maxNumberOfRectangles = 8
    let minNumberOfRectangles = 3
    let matchingThreshold: CGFloat = 40.0
    let minNumberOfMatches = 2

    func add(_ rectangleFeature: CIRectangleFeature, currentlyDisplayedRectangle currentRectangle: CIRectangleFeature?, completion: (CIRectangleFeature) -> Void) {
        let rectangleMatch = RectangleMatch(rectangleFeature: rectangleFeature)
        rectanglesQueue.append(rectangleMatch)
        
        guard rectanglesQueue.count >= minNumberOfRectangles else {
            return
        }
        
        if rectanglesQueue.count > maxNumberOfRectangles {
            rectanglesQueue.removeFirst()
        }
        
        updateRectangleMatches()
        
        if let bestRectangle = self.bestRectangle(withCurrentlyDisplayedRectangle: currentRectangle) {
            if let previousRectangle = currentRectangle,
                bestRectangle.rectangleFeature.isWithin(matchingThreshold, ofRectangleFeature: previousRectangle) {
                return
            } else if bestRectangle.matchingScore >= minNumberOfMatches {
                completion(bestRectangle.rectangleFeature)
            }
        }
        
    }
    
    private func bestRectangle(withCurrentlyDisplayedRectangle currentRectangle: CIRectangleFeature?) -> RectangleMatch? {
        var bestMatch: RectangleMatch?
        
        rectanglesQueue.reversed().forEach { (rectangle) in
            guard let best = bestMatch else {
                bestMatch = rectangle
                return
            }
            
            if rectangle.matchingScore > best.matchingScore {
                return
            } else if rectangle.matchingScore == best.matchingScore {
                guard let currentRectangle = currentRectangle else {
                    return
                }
                
                if best.rectangleFeature.isWithin(matchingThreshold, ofRectangleFeature: currentRectangle) {
                    return
                } else if rectangle.rectangleFeature.isWithin(matchingThreshold, ofRectangleFeature: currentRectangle) {
                    bestMatch = rectangle
                }
            }
        }
        
        return bestMatch
    }
    
    private func updateRectangleMatches() {
        resetMatchingScores()
        
        for (i, currentRect) in rectanglesQueue.enumerated() {
            for (j, rect) in rectanglesQueue.enumerated() {
                if j > i  && currentRect.matches(rect.rectangleFeature, withThreshold: matchingThreshold) {
                    currentRect.matchingScore += 1
                    rect.matchingScore += 1
                }
            }
        }
    }
    
    private func resetMatchingScores() {
        rectanglesQueue = rectanglesQueue.map { (rectange) -> RectangleMatch in
            rectange.matchingScore = 0
            return rectange
        }
    }
    
}
