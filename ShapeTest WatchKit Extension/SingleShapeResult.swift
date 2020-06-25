//
//  SingleShapeResult.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 6/24/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import UIKit

class SingleShapeResult {
    var shapeNumber: Int
    var reactionTime: Float
    
    var shapeName: String
    var previousShapeName: String
    
    var score: Int
    
    init(shapeNumber: Int, reactionTime: Float, shapeName: String, previousShapeName: String, score: Int) {
        self.shapeNumber = shapeNumber
        self.reactionTime = reactionTime
        
        self.shapeName = shapeName
        self.previousShapeName = previousShapeName
        
        self.score = score
    }
}
