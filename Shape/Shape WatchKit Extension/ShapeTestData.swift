//
//  ShapeTestData.swift
//  Shape WatchKit Extension
//
//  Created by Mariana on 8/13/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import Foundation

protocol Prompt {
    var canMoveToNext: Bool { get }
    var promptAsDictionary: [String:Any?] {get}
}

class ShapeTest : Prompt {

    
    var resultsArray: [SingleShapeResult] = [SingleShapeResult]()
    
    var canMovetoNext: Bool {
        return false
    }
    
    //number of shapes the user had in the test -> singleShapeResult
    private var ShapeCount: Int {
        return resultsArray.count
    }
    
    //add each singleShapeResult to the resutlsArray
    func addShapeResult(shapeName: String, previousShapeName: String, reactionTime: Float, score: Int){
        resultsArray.append(SingleShapeResult(shapeNumber: ShapeCount + 1, shapeName: shapeName, previousShapeName: previousShapeName, reactionTime: reactionTime, score: score))
    }
    
    var promptAsDictionary: [String : Any?] {
        
    }
    
    
    
    
}
