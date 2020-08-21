//
//  ShapeTestResult.swift
//  Shape WatchKit Extension
//
//  Created by Mariana on 8/20/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import Foundation

class ShapeTestResult {
    var roundDate: Date
    var numberRight: Int
    var numberAttempted: Int
    
    init(roundDate: Date, numberRight: Int, numberAttempted: Int){
        self.roundDate = roundDate
        self.numberRight = numberRight
        self.numberAttempted = numberAttempted
    }
}
