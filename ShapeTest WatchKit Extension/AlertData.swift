//
//  AlertData.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 6/24/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import Foundation

protocol Prompt {
    var currentQuestionTitle: String { get }
    var currentQuestion: String { get }
    var canMoveToNext: Bool { get }
    var promptAsDictionary: [String:Any?] { get }
}

class ShapeTest : Prompt {
    let duration = Constants.shapeTestDuration
    
    var resultsArray: [SingleShapeResult] = [SingleShapeResult]()
    
    var completedDuration: Int? = nil
    
    var finishedTime: Date? = nil
    
    private var shapeCount: Int {
        return resultsArray.count
    }
    
    var currentQuestionTitle: String {
        return "Shape Test"
    }
    
    var currentQuestion: String {
        return "Shape Test"
    }
    
    var canMoveToNext: Bool {
        return false
    }
    
    func addShapeResult(reactionTime: Float, shapeName: String, previousShapeName: String, score: Int) {
        resultsArray.append(SingleShapeResult(shapeNumber: shapeCount+1, reactionTime: reactionTime, shapeName: shapeName, previousShapeName: previousShapeName, score: score))
    }
    
    var promptAsDictionary: [String : Any?] {
        if finishedTime != nil && completedDuration != nil {
            var resultsDictionaries = [[String:Any]]()
            
            for result in resultsArray {
                let resultAsDictionary: [String:Any] = [
                    "trial_number": result.shapeNumber,
                    "score": result.score,
                    "reaction_time": result.reactionTime,
                    "current_shape": result.shapeName,
                    "previous_shape": result.previousShapeName
                ]
                
                resultsDictionaries.append(resultAsDictionary)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let finsihedTimeString = dateFormatter.string(from: finishedTime!)
            
            return [
                "finished_time": finsihedTimeString,
                "completed_duration": completedDuration!,
                "shape_results": resultsDictionaries
            ]
        } else {
            return [String:Any?]()
        }
    }
}
