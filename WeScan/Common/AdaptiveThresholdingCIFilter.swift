//
//  AdaptiveThresholdingCIFilter.swift
//  WeScan
//
//  Created by Julian Schiavo on 13/11/2018.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import CoreImage

final class AdaptiveThresholdCIFilter: CIFilter {
    var inputImage: CIImage?
    var firstInputEdge: CGFloat = 0.25
    var secondInputEdge: CGFloat = 0.75
    
    var colorKernel = CIColorKernel(source:
        "kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1)" +
            "{" +
            "    float luma = dot(pixel.rgb, vec3(0.2126, 0.7152, 0.0722));" +
            "    float threshold = smoothstep(inputEdgeO, inputEdge1, luma);" +
            "    return vec4(threshold, threshold, threshold, 1.0);" +
        "}"
    )
    
    override var outputImage: CIImage! {
        guard let inputImage = inputImage, let colorKernel = colorKernel else { return nil }
        return colorKernel.apply(extent: inputImage.extent, arguments: [inputImage, firstInputEdge, secondInputEdge])
    }
}
