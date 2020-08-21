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
    var promptAsDictionary: [String:Any?] { get }
}

class ShapeTest : Prompt {
    
    let duration = Constants.shapeTestDuration
    var resultsArray: [SingleShapeResult] = [SingleShapeResult]()
    
    let FinalResult: [ShapeTestResult] = [ShapeTestResult]()
    
    var canMoveToNext: Bool {
        return false
    }
    
    //number of shapes the user had in the test -> singleShapeResult
    private var ShapeCount: Int {
        return resultsArray.count
    }
    
    //add each singleShapeResult to the resutlsArray
    func addShapeResult(shapeName: String, previousShapeName: String, reactionTime: Float, score: Int) {
        
        resultsArray.append(SingleShapeResult(shapeNumber: ShapeCount + 1, shapeName: shapeName, previousShapeName: previousShapeName, reactionTime: reactionTime, score: score))
        
    }
    
    
    
    //get results per shapeTest
    var completedDuration: Int? = nil
    var finishedTime: Date? = nil
    
    var promptAsDictionary: [String : Any?] {
        if finishedTime != nil && completedDuration != nil {
            var resultsDictionaries = [[String:Any]]()
            
            for result in resultsArray {
                let resultAsDictionary: [String:Any] = [
                    "shapeNumber": result.shapeNumber,
                    "score" : result.score,
                    "reactionTime": result.reactionTime,
                    "currentShape": result.shapeName,
                    "previousShape": result.previousShapeName
                ]
                resultsDictionaries.append(resultAsDictionary)
            }
            
            //conversion between dates and their textual representation
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let timeString = dateFormatter.string(from: finishedTime!)
            
            return [
                "finishedTime": timeString,
                "completedDuration": completedDuration!,
                "shapeResults": resultsDictionaries
            ]
        } else {
            return [String:Any?]()
        }
    }
    
}
