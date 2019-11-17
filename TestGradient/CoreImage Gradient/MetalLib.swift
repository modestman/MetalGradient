//
//  MetalLib.swift
//  TestGradient
//
//  Created by Anton Glezman on 17.11.2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import Foundation

final class MetalLib {
    private static var url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
    static var data = try! Data(contentsOf: url)
}
