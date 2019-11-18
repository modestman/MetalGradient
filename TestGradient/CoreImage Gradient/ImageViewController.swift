//
//  ImageViewController.swift
//  TestGradient
//
//  Created by Anton Glezman on 17.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import CoreImage
import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet private weak var mtkImageView: MTKCIImageView!
    
    @IBOutlet private weak var startAngleSlider: UISlider! {
        didSet {
            startAngleSlider.maximumValue = 2 * .pi
            startAngleSlider.value = Float(startAngle)
        }
    }
    @IBOutlet private weak var endAngleSlider: UISlider! {
        didSet {
            endAngleSlider.maximumValue = 2 * .pi
            endAngleSlider.value = Float(endAngle)
        }
    }
    
    private var startAngle: CGFloat = 0.0
    private var endAngle: CGFloat = 2 * .pi
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        if sender == startAngleSlider {
            startAngle = value
        } else if sender == endAngleSlider {
            endAngle = value
        }
        render()
    }
    
    private func render() {
        
        let frame = mtkImageView.bounds
        let bottomColor = CIColor.black
        let topColor = CIColor.red

        let gradientFilter = ConicGradientFilter()
        gradientFilter.setValue(bottomColor, forKey: "inputColor0")
        gradientFilter.setValue(topColor, forKey: "inputColor1")
        gradientFilter.setValue(CIVector(cgRect: frame), forKey: "rect")
        gradientFilter.setValue(CIVector(x: startAngle), forKey: "startAngle")
        gradientFilter.setValue(CIVector(x: endAngle), forKey: "endAngle")
        guard let gradient = gradientFilter.outputImage?.cropped(to: frame) else { return }
        
        let sectorFilter = SectorShapeFilter()
        sectorFilter.setValue(CIVector(cgRect: frame), forKey: "rect")
        sectorFilter.setValue(CIVector(x: startAngle), forKey: "startAngle")
        sectorFilter.setValue(CIVector(x: endAngle), forKey: "endAngle")
        guard let sector = sectorFilter.outputImage?.cropped(to: frame) else { return }
        
        let maskFilter = CIFilter(name: "CIBlendWithMask")
        maskFilter?.setValue(sector, forKey: "inputMaskImage")
        maskFilter?.setValue(gradient, forKey: "inputImage")
            
        mtkImageView.image = maskFilter?.outputImage
    }
}


