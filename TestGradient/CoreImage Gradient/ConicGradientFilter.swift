//
//  ConicGradientFilter.swift
//  TestGradient
//
//  Created by Anton Glezman on 16.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation
import CoreImage

final class ConicGradientFilter: CIFilter {
    
    @objc dynamic var inputColor0: CIColor = CIColor.white
    @objc dynamic var inputColor1: CIColor = CIColor.black
    @objc dynamic var rect: CIVector = CIVector(cgRect: CGRect.zero)
    @objc dynamic var centerPoint: CIVector = CIVector(x: 0.5, y: 0.5)
    @objc dynamic var startAngle: CIVector = CIVector(x: 0)
    @objc dynamic var endAngle: CIVector = CIVector(x: 2 * .pi)

    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Conic gradient",

            "inputColor0": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIColor",
                kCIAttributeDisplayName: "Input Color 0",
                kCIAttributeDefault: CIColor.white,
                kCIAttributeType: kCIAttributeTypeColor],

            "inputColor0": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIColor",
                kCIAttributeDisplayName: "Input Color 0",
                kCIAttributeDefault: CIColor.black,
                kCIAttributeType: kCIAttributeTypeColor],
            
            "rect": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "Frame Rect",
                kCIAttributeDefault: CIVector(cgRect: CGRect.zero),
                kCIAttributeType: kCIAttributeTypeRectangle],
            
            "centerPoint": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "Center Point",
                kCIAttributeDefault: CIVector(x: 0.0, y: 0.0),
                kCIAttributeType: kCIAttributeTypePosition],
            
            "startAngle": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "Start Angle",
                kCIAttributeDefault: CIVector(x: 0),
                kCIAttributeType: kCIAttributeTypePosition],
            
            "endAngle": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "End Angle",
                kCIAttributeDefault: CIVector(x: 2 * .pi),
                kCIAttributeType: kCIAttributeTypePosition],
        ]
    }
    
    override var outputImage: CIImage? {
        let kernel = try? CIColorKernel(functionName: "conicGradient", fromMetalLibraryData: MetalLib.data)
        return kernel?.apply(
            extent: CGRect.infinite,
            arguments: [inputColor0, inputColor1, rect, centerPoint, startAngle, endAngle])
    }
}
