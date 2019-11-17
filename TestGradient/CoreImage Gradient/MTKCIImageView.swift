  //
//  MTKCIImageView.swift
//  Fil
//
//  Created by Muukii on 9/27/15.
//  Copyright © 2015 muukii. All rights reserved.
//

import Foundation
import Metal
import MetalKit
  
class MTKCIImageView: MTKView {
    
    var image: CIImage? {
        didSet {
            self.draw()
        }
    }
    
    let context: CIContext
    let commandQueue: MTLCommandQueue
    
    convenience init(frame: CGRect) {
        let device = MTLCreateSystemDefaultDevice()
        self.init(frame: frame, device: device)
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        guard let device = device else {
            fatalError("Can't use Metal")
        }
        commandQueue = device.makeCommandQueue(maxCommandBufferCount: 5)!
        context = CIContext(mtlDevice: device, options: [CIContextOption.useSoftwareRenderer: false])
        super.init(frame: frameRect, device: device)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Can't use Metal")
        }
        commandQueue = device.makeCommandQueue(maxCommandBufferCount: 5)!
        context = CIContext(mtlDevice: device, options: [CIContextOption.useSoftwareRenderer: false])
        super.init(coder: aDecoder)
        self.device = device
        commonInit()
    }
    
    private func commonInit() {
        self.framebufferOnly = false
        self.enableSetNeedsDisplay = false
        self.isPaused = true
        self.clearColor = MTLClearColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.backgroundColor = .clear
    }
    
    
    override func draw(_ rect: CGRect) {
        
        guard let image = self.image else { return }
        
        let dRect = destRect
        
        let drawImage: CIImage
        
        if dRect == image.extent {
            drawImage = image
        } else {
            let scale = max(dRect.height / image.extent.height, dRect.width / image.extent.width)
            drawImage = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        }
        
        let commandBuffer = commandQueue.makeCommandBufferWithUnretainedReferences()
        guard let texture = self.currentDrawable?.texture else {
            return
        }
        let colorSpace = drawImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        
        context.render(drawImage, to: texture, commandBuffer: commandBuffer, bounds: dRect, colorSpace: colorSpace)
        
        commandBuffer?.present(self.currentDrawable!)
        commandBuffer?.commit()
    }
    
    private var destRect: CGRect {
        let scale: CGFloat = UIScreen.main.scale
        return self.bounds.applying(CGAffineTransform(scaleX: scale, y: scale))
    }
}
