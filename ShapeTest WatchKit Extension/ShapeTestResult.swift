//
//  ShapeTestResult.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 6/27/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import UIKit

class ShapeTestResult {
    var roundDate: Date
    var numberRight: Int
    var attempted: Int
    
    init(roundDate: Date, numberRight: Int, attempted: Int) {
        self.roundDate = roundDate
        self.numberRight = numberRight
        self.attempted = attempted
    }
}
