//
//  ConicGradient.swift
//  TestGradient
//
//  Created by Anton Glezman on 31.10.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

final class ConicGradient: UIView {
    
    let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        make()
    }
    
    func make() {
        let radius = bounds.size.width / 2
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let bezierPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi ,
            clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
         
        gradient.frame = bounds
        gradient.colors = [UIColor.blue.cgColor, UIColor.yellow.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.01)
        
        gradient.type = .conic
        gradient.mask = maskLayer
        
        self.layer.addSublayer(gradient)
    }
}
