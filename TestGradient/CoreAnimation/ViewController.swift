//
//  ViewController.swift
//  TestGradient
//
//  Created by Anton Glezman on 31.10.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var conicGradient: ConicGradient!
    @IBOutlet private weak var startPointXSlider: UISlider!
    @IBOutlet private weak var startPointYSlider: UISlider!
    @IBOutlet private weak var endPointXSlider: UISlider!
    @IBOutlet private weak var endPointYSlider: UISlider!
    
    @IBOutlet private weak var startPointXLabel: UILabel!
    @IBOutlet private weak var startPointYLabel: UILabel!
    @IBOutlet private weak var endPointXLabel: UILabel!
    @IBOutlet private weak var endPointYLabel: UILabel!
    
    
    @IBOutlet private weak var pieChart: PieChart!
    @IBOutlet private weak var pieChartSlider: UISlider!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = CGFloat(sender.value)
        if sender == startPointXSlider {
            conicGradient.gradient.startPoint.x = value
            startPointXLabel.text = "\(value)"
        } else if sender == startPointYSlider {
            conicGradient.gradient.startPoint.y = value
            startPointYLabel.text = "\(value)"
        } else if sender == endPointXSlider {
            conicGradient.gradient.endPoint.x = value
            endPointXLabel.text = "\(value)"
        } else if sender == endPointYSlider {
            conicGradient.gradient.endPoint.y = value
            endPointYLabel.text = "\(value)"
        }
        
        
        if sender == pieChartSlider {
            pieChart.values = [Double(value), 240.0, 40.0, 100.0, 80]
        }
    }

}

