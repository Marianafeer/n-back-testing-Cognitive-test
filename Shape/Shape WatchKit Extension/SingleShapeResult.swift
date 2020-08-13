//
//  SingleShapeResult.swift
//  Shape WatchKit Extension
//
//  Created by Mariana on 8/13/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import Foundation

class SingleShapeResult {
    var shapeNumber: Int
    
    var shapeName: String
    var previousShapeName: String
    
    var reactionTime: Float
    
    var score: Int
    
    init(shapeNumber: Int, shapeName: String, previousShapeName: String, reactionTime: Float, score: Int) {
        self.shapeNumber = shapeNumber
        
        self.shapeName = shapeName
        self.previousShapeName = previousShapeName
        
        self.reactionTime = reactionTime
        self.score = score
    }
}
