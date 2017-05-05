//
//  LineChartFormatter.swift
//  GasPal
//
//  Created by Tyler Hackley Lewis on 5/5/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(LineChartFormatter)
public class LineChartFormatter: NSObject, IAxisValueFormatter {

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
    
}
