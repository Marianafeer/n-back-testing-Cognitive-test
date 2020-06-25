//
//  RunShapeTestInterfaceController.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 6/23/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import WatchKit
import Foundation


class RunShapeTestInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var doneButton: WKInterfaceButton!
    
    
    
    @IBOutlet weak var shapeTestImage: WKInterfaceImage!
    @IBOutlet weak var shapeTestTimer: WKInterfaceTimer!
    @IBOutlet weak var startTimerLabel: WKInterfaceLabel!
    
    
    private var startSecondsLeft: Int = 3
    private var mainTimerSecondsLeft: Int? = nil
    private var timerLeft: Int = 48
    private var timer: Timer?
    
    @IBOutlet weak var yesButton: WKInterfaceButton!
    @IBOutlet weak var noButton: WKInterfaceButton!
    
    private var shapeTestPrompt = ShapeTest()
    
    private var currentShapeIndex: Int = 0
    private var previousShapeIndex: Int = 0
    private var currentShapeIsRepeat = false
    private var currentShapeStartTime = Date()
    
    private var currentShapeName: String {
        return Constants.shapeNames[currentShapeIndex]
    }
    
    private var previousShapeName: String {
        return Constants.shapeNames[previousShapeIndex]
    }
    
    
    let images = ["Circle.png", "Diamond.png", "Triangle.png"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        startShapesTest()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        timer?.invalidate()
        
        
    }
    private func startShapesTest() {
        //mainTimerSecondsLeft = shapeTestPrompt.duration
        setTimerLabels()
        showNewShape()
        showStartView()
        
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick(){
        startSecondsLeft -= 1
        startTimerLabel?.setText("\(startSecondsLeft)")
        
        if startSecondsLeft == 0 {
            print("timer = 0")
            switchToMainTest()
            }
        //auxx for timer
        timerLeft -= 1
        if timerLeft == 0 {
            print("Timer left = 0")
            
            showDoneView()
            
        }
        
    }
    
    private func setTimerLabels() {
        startTimerLabel?.setText("\(startSecondsLeft)")
    }

    //when countdown is 0 and we actually start running the test
    
    private func switchToMainTest() {
        shapeTestTimer.setDate(NSDate(timeIntervalSinceNow:  45) as Date)
        shapeTestTimer.start()
        
        showTestView()
    }
    
    
    private func showStartView(){
        doneButton.setHidden(true)
        shapeTestImage.setHidden(false)
        
        
        yesButton.setHidden(true)
        noButton.setHidden(true)
        shapeTestTimer.setHidden(true)
        
        startTimerLabel.setHidden(false)
        
        
    }
    private func showTestView(){
        getImage()
        startTimerLabel.setHidden(true)
        
        shapeTestTimer.setHidden(false)
        shapeTestImage.setHidden(false)
        yesButton.setHidden(false)
        noButton.setHidden(false)
    }
    
    private func showDoneView(){
        doneButton.setHidden(false)
        shapeTestImage.setHidden(true)
        
        yesButton.setHidden(true)
        noButton.setHidden(true)
        shapeTestTimer.setHidden(false)
        
        startTimerLabel.setHidden(true)
    }
    
    private func showNewShape(){
        previousShapeIndex = currentShapeIndex
        
        var newShapeIndex = pickNewShapeIndex()
        
        //Avoid repeating the same shape more than once:
        while currentShapeIsRepeat && newShapeIndex == currentShapeIndex {
            newShapeIndex = pickNewShapeIndex()
        }
        
        currentShapeIndex = newShapeIndex
        currentShapeIsRepeat = currentShapeIndex == previousShapeIndex
        updateShapeViewToCurrent()
        
        currentShapeStartTime = Date()
        
        
    }
    
    
    private func getImage() {
        
        let randomImage = images.randomElement()
        let currentImage = UIImage(named: "\(randomImage!)")
        
        shapeTestImage.setImage(currentImage)
        
    }
    
    
    
    
    
    //Bryans code
    
    private func pickNewShapeIndex() -> Int {
        
        return 1
    }
    
    private func updateShapeViewToCurrent() {
        if shapeTestImage != nil{
            shapeTestImage.setImage(UIImage(named: currentShapeName))
            shapeTestImage.setHidden(false)
        }
    }
    
    @IBAction func yesButtonPressed() {
        //handleButtonPress(answerIsForSameShape: true)
        getImage()
    }
    
    @IBAction func noButtonPressed() {
        //handleButtonPress(answerIsForSameShape: false)
        getImage()
    }
    
    private func handleButtonPress(answerIsForSameShape: Bool) {
        let currentShapeSameAsPrevious = currentShapeIndex == previousShapeIndex
        let answerIsCorrect = currentShapeSameAsPrevious ? answerIsForSameShape : !answerIsForSameShape
           
        let shapeEndTime = Date()
        let shapeReactionTime = shapeEndTime.timeIntervalSince(currentShapeStartTime)
           
        let score = answerIsCorrect ? 1 : 0
           
        shapeTestPrompt.addShapeResult(reactionTime: Float(shapeReactionTime), shapeName: currentShapeName, previousShapeName: previousShapeName, score: score)
           
        shapeTestImage.setHidden(true)
           
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.shapeTestShowDelay, execute: {
            self.showNewShape()
        })
    }
       
    @IBAction func backPressed() {
           finishTest()
    }
       
    
    
    private func finishTest() {
        
        /*
        if mainTimerSecondsLeft != nil {
            shapeTestPrompt.completedDuration = shapeTestPrompt.duration - mainTimerSecondsLeft!
            shapeTestPrompt.finishedTime = Date()
        }
          
        dismiss()*/
        
        pushController(withName: "InterfaceController", context: nil)
 
    }
    
    
    

}
