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
    private var testTimerSecondsLeft: Int? = nil
    
    //UI elements
    @IBOutlet weak var startCountdownLabel: WKInterfaceLabel!
    @IBOutlet weak var shapeImage: WKInterfaceImage!
    @IBOutlet weak var testTimer: WKInterfaceTimer!
    @IBOutlet weak var noButton: WKInterfaceButton!
    @IBOutlet weak var yesButton: WKInterfaceButton!
    
    //Single ShapeInfo
    private var currentShapeIndex: Int = 0
    private var previousShapeIndex: Int = 0
    private var currentShapeRepeat = false
    private var currentShapeStartTime = Date()
    
    
    private var testScore: Int = 0
    private var numberOfShapes: Int = 0
    
    
    //Get currentShapeName and previousShapeName by index
    private var currentShapeName: String {
        return Constants.shapeNames[currentShapeIndex]
    }
    private var previousShapeName: String {
        return Constants.shapeNames[previousShapeIndex]
    }
    
    var shapeTestPrompt = ShapeTest()
    
    
    //------------
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        /*
        let filename = "Test"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropiateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(filename ).appendingPathExtension("txt")
        */
        
        startShapeTest()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        //Cancel is pressed
        print("Test Canceled or Finished \n")
        finishTest()
        timer?.invalidate()
        
    }

    
    @objc func startShapeTest() {
        testTimerSecondsLeft = shapeTestPrompt.duration
        
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
        
        if startCountdown <= 0 && testTimerSecondsLeft != nil {
            testTimerSecondsLeft! -= 1
        }
        
        if testTimerSecondsLeft != nil && testTimerSecondsLeft! <= 0 {
            print("About to finish the test \n")
            //end test
            finishTest()
        }
    }
    
    @objc func switchToMainTest(){
        showTestView()
        showNewShape()
    }
    
    //UI Views
    @objc func showStartView(){
        testTimer.setHidden(true)
        startCountdownLabel.setHidden(false)
        noButton.setEnabled(false)
        yesButton.setEnabled(false)
        
        shapeImage?.setHidden(false)
    }
    
    @objc func showTestView(){
        testTimer.setHidden(false)
        startCountdownLabel.setHidden(true)
        noButton.setEnabled(true)
        yesButton.setEnabled(true)
        
        shapeImage.setHidden(false)
        
        testTimer.setDate(NSDate(timeIntervalSinceNow:  45) as Date)
        testTimer.start()
    }
    
    @objc func testEndedView() {
        testTimer.setHidden(true)
        startCountdownLabel.setHidden(true)
        noButton.setHidden(true)
        yesButton.setHidden(true)
        
        shapeImage?.setHidden(true)
    }
    
    //ShapeTest starts running
    @objc func pickNewShapeIndex() -> Int {
        return Int(arc4random_uniform(UInt32(Constants.numberShapeTestShapes)))
    }
    
    @objc func showNewShape(){
        //Keep track of number of Shapes
        numberOfShapes += 1
        
        previousShapeIndex = currentShapeIndex
        
        var newShapeIndex = pickNewShapeIndex()
        
        //Avoid index repetition more than once
        while currentShapeRepeat && newShapeIndex == currentShapeIndex {
            newShapeIndex = pickNewShapeIndex()
        }
        
        currentShapeIndex = newShapeIndex
        
        //update currentShapeRepeat if currentShapeIndex = previousShapeIndex
        currentShapeRepeat = currentShapeIndex == previousShapeIndex
        
        updateShape()
        
        currentShapeStartTime = Date()
                
    }
    @objc func updateShape(){
        if shapeImage != nil {
            shapeImage.setImage(UIImage(named: currentShapeName))
            shapeImage!.setHidden(false)
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
        
        testScore += score
        
        //adding results per shape
        shapeTestPrompt.addShapeResult(shapeName: currentShapeName, previousShapeName: previousShapeName, reactionTime: Float(shapeReactionTime), score: score)
        
        
        print("PreviousShapeName: " + previousShapeName)
        print("ReactionTime:  \(Float(shapeReactionTime))")
        print("Score:  \(score)")
        print("CurrentShapeName:  " + currentShapeName)
        print("\n")
        
        
        shapeImage.setHidden(true)
        
        //run code after a delay: 0.3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showImageDelay, execute: {
            self.showNewShape()
        })
    }
    
    //End test
    private func finishTest(){
        if testTimerSecondsLeft != nil {
            shapeTestPrompt.completedDuration = shapeTestPrompt.duration - testTimerSecondsLeft!
            shapeTestPrompt.finishedTime = Date()
        
            print("Final Score: \(testScore)")
            print("NumberOfShapes:  \(numberOfShapes)")
            
            testEndedView()
            
        }
        
        //dismiss()
    }
    
}
