//
//  PieChart.swift
//  TestGradient
//
//  Created by Anton Glezman on 02.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

final class PieChart: UIView {
    
    // MARK: - Public properties
    
    var values = [150.0, 240.0, 40.0, 100.0, 80] {
        didSet {
            updateSegments()
        }
    }
    
    
    // MARK: - Private properties
    
    private var fractions: [Double] {
        let sum = values.reduce(0, +)
        return values.map { $0 / sum }//.sorted(by: >)
    }
    
    private let lightColors: [UIColor] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    private let darkColors: [UIColor] = [#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)]
    private var segments: [CAGradientLayer] = []
    
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makePieChart()
    }
    
    
    // MARK: - Private methods
    
    private func makePieChart() {
        segments = []
        var prevAngle: CGFloat = 0
        var radius = bounds.size.width / 2
        var i = 0
        for value in fractions {
            let startAngle = prevAngle
            let endAngle = prevAngle + CGFloat(value * 2 * .pi)
            let segment = makeSegmet(
                startAngle: startAngle,
                endAngle: endAngle,
                startColor: darkColors[i].cgColor,
                endColor: lightColors[i].cgColor,
                radius: radius)
            segments.append(segment)
            layer.addSublayer(segment)
            
            prevAngle = endAngle
            radius = radius * 0.9
            i += 1
        }
    }
    
    private func updateSegments() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        var i = 0
        var prevAngle: CGFloat = 0
        var radius = bounds.size.width / 2
        for value in fractions {
            let segment = segments[i]
            let startAngle = prevAngle
            let endAngle = prevAngle + CGFloat(value * 2 * .pi)
            let mask = makeMaskLayer(startAngle: startAngle, endAngle: endAngle, radius: radius)
            segment.mask = mask
            segment.locations = [0.0, gradientEndLocationFor(startAngle, endAngle)]
            segment.endPoint = gradientEndPointFor(angle: startAngle)
            
            prevAngle = endAngle
            radius = radius * 0.9
            i += 1
        }
        CATransaction.commit()
    }
    
    private func makeSegmet(
        startAngle: CGFloat,
        endAngle: CGFloat,
        startColor: CGColor,
        endColor: CGColor,
        radius: CGFloat) -> CAGradientLayer {

        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.0, gradientEndLocationFor(startAngle, endAngle)]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = gradientEndPointFor(angle: startAngle)
        gradient.type = .conic
        gradient.mask = makeMaskLayer(startAngle: startAngle, endAngle: endAngle, radius: radius)
        return gradient
    }
    
    private func makeMaskLayer(
        startAngle: CGFloat,
        endAngle: CGFloat,
        radius: CGFloat) -> CALayer {
        
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let bezierPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)
        bezierPath.addLine(to: center)
        bezierPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        return maskLayer
    }
    
    private func gradientEndPointFor(angle: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle) + 0.5, y: sin(angle) + 0.5)
    }
    
    private func gradientEndLocationFor(_ startAngle: CGFloat, _ endAngle: CGFloat) -> NSNumber {
        let endLocation = (endAngle - startAngle) / (2 * .pi)
        return NSNumber(value: Float(endLocation))
    }
}
