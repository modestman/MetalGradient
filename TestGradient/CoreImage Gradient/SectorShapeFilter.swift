//
//  SectorShapeFilter.swift
//  TestGradient
//
//  Created by Anton Glezman on 17.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation
import CoreImage

final class SectorShapeFilter: CIFilter {
    
    @objc dynamic var rect: CIVector = CIVector(cgRect: CGRect.zero)
    @objc dynamic var startAngle: CIVector = CIVector(x: 0.0)
    @objc dynamic var endAngle: CIVector = CIVector(x: 2 * .pi)

    
    override var attributes: [String : Any] {
        return [
            kCIAttributeFilterDisplayName: "Sector shape",

            "rect": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "Frame Rect",
                kCIAttributeDefault: CIVector(cgRect: CGRect.zero),
                kCIAttributeType: kCIAttributeTypeRectangle],
            
            "startAngle": [
                kCIAttributeIdentity: 0,
                kCIAttributeClass: "CIVector",
                kCIAttributeDisplayName: "Start Angle",
                kCIAttributeDefault: CIVector(x: 0.0),
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
        let kernel = try? CIColorKernel(functionName: "sector", fromMetalLibraryData: MetalLib.data)
        return kernel?.apply(
            extent: CGRect.infinite,
            arguments: [rect, startAngle, endAngle])
    }
}
