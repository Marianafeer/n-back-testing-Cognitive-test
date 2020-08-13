//
//  RunShapeTestInterfaceController.swift
//  Shape WatchKit Extension
//
//  Created by Mariana on 7/29/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import WatchKit
import Foundation


class RunShapeTestInterfaceController: WKInterfaceController {
    
    private var timer: Timer?
    private var startCountdown: Int = 3
    
    //UI elements
    @IBOutlet weak var startCountdownLabel: WKInterfaceLabel!
    @IBOutlet weak var shapeImage: WKInterfaceImage!
    @IBOutlet weak var testTimer: WKInterfaceTimer!
    @IBOutlet weak var noButton: WKInterfaceButton!
    @IBOutlet weak var yesButton: WKInterfaceButton!
    
    //ShapeInfo
    private var currentShapeIndex: Int = 0
    private var previousShapeIndex: Int = 0
    private var currentShapeRepeat = false
    private var currentShapeStartTime = Date()
    
    //Get currentShapeName and previousShapeName by index
    private var currentShapeName: String {
        return Constants.shapeNames[currentShapeIndex]
    }
    private var previousShapeName: String {
        return Constants.shapeNames[currentShapeIndex]
    }
    
    shapeTestPrompt = ShapeTest()
    
    
    //------------
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        startShapeTest()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @objc func startShapeTest() {
        showStartView()
        showNewShape()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick(){
        startCountdown -= 1
        startCountdownLabel.setText("\(startCountdown)")
        
        if startCountdown == 0 {
            switchToMainTest()
        }
    }
    
    @objc func switchToMainTest(){
        showTestView()
        //showNewShape()
    }
    
    //UI Views
    @objc func showStartView(){
        testTimer.setHidden(true)
        startCountdownLabel.setHidden(false)
        noButton.setEnabled(false)
        yesButton.setEnabled(false)
    }
    
    @objc func showTestView(){
        testTimer.setHidden(false)
        startCountdownLabel.setHidden(true)
        noButton.setEnabled(true)
        yesButton.setEnabled(true)
        testTimer.setDate(NSDate(timeIntervalSinceNow:  45) as Date)
        testTimer.start()
    }
    
    //ShapeTest starts running
    @objc func pickNewShapeIndex() -> Int {
        return Int(arc4random_uniform(UInt32(Constants.numberShapeTestShapes)))
    }
    
    @objc func showNewShape(){
        previousShapeIndex = currentShapeIndex
        
        var newShapeIndex = pickNewShapeIndex()
        
        //Avoid index repetition more than once
        while currentShapeRepeat && currentShapeIndex == newShapeIndex {
            newShapeIndex = pickNewShapeIndex()
        }
        currentShapeIndex = newShapeIndex
        //update currentShapeRepeat if currentShapeIndex = previousShapeIndex
        currentShapeRepeat = currentShapeIndex == previousShapeIndex
        
        currentShapeStartTime = Date()
        updateShape()
                
    }
    @objc func updateShape(){
        if shapeImage != nil {
            shapeImage.setImage(UIImage(named: currentShapeName))
        }
    }
    //YES-NO buttons are pressed -> showNewShape and check accuracy with previousShape
    
    @IBAction func noButtonPressed() {
        handdleButtonPress(answerIsForSameShape: false)
    }
    @IBAction func yesButtonPressed() {
        handdleButtonPress(answerIsForSameShape: true)
    }
    
    //evaluate users response
    private func handdleButtonPress(answerIsForSameShape:Bool) {
        
        let currentShapeSameAsPrevious = currentShapeIndex == previousShapeIndex
        let answerIsCorrect = currentShapeSameAsPrevious ? answerIsForSameShape : !answerIsForSameShape
        
        let shapeEndTime = Date()
        let shapeReactionTime = shapeEndTime.timeIntervalSince(currentShapeStartTime)
        
        let score = answerIsCorrect ? 1 : 0
        //adding results per shape
        //
    }
    
    
    
}
