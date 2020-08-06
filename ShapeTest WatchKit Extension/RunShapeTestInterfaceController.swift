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
    
    
    @IBOutlet weak var plusOneLabel: WKInterfaceLabel!
    @IBOutlet weak var doneButton: WKInterfaceButton!
    
    
    @IBOutlet weak var shapeTestImage: WKInterfaceImage!
    @IBOutlet weak var shapeTestTimer: WKInterfaceTimer!
    @IBOutlet weak var startTimerLabel: WKInterfaceLabel!
    
    
    private var startSecondsLeft: Int = 3
    private var TestSecondsLeft: Int? = nil
    private var timerLeft: Int = 48
    private var timer: Timer?
    
    @IBOutlet weak var yesButton: WKInterfaceButton!
    @IBOutlet weak var noButton: WKInterfaceButton!
    
    private var shapeTestPrompt = ShapeTest()
    
    private var currentShapeIndex: Int = 0
    private var previousShapeIndex: Int = 0
    private var currentShapeIsRepeat = false
    private var currentShapeStartTime = Date()
    
    private var currentScore: Int = 0
    
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
        //keeping track of the secondsLeft
        TestSecondsLeft = shapeTestPrompt.duration
        setTimerLabels()
        showNewShape()
        showStartView()
         
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick(){
        startSecondsLeft -= 1
        startTimerLabel?.setText("\(startSecondsLeft)")
        
        if startSecondsLeft == 0 {
            print("timer = 0 Sec")
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
        showNewShape()
    }
    
    
    private func showStartView(){
        doneButton.setHidden(true)
        shapeTestImage.setHidden(false)
        
        yesButton.setHidden(true)
        noButton.setHidden(true)
        shapeTestTimer.setHidden(true)
        startTimerLabel.setHidden(false)
        
        plusOneLabel.setHidden(true)
    }
    
    private func showTestView(){
        //getImage()
        startTimerLabel.setHidden(true)
        
        shapeTestTimer.setHidden(false)
        shapeTestImage.setHidden(false)
        yesButton.setHidden(false)
        noButton.setHidden(false)
        
        plusOneLabel.setHidden(true)
    }
    
    private func showDoneView(){
        doneButton.setHidden(false)
        shapeTestImage.setHidden(true)
        
        yesButton.setHidden(true)
        noButton.setHidden(true)
        shapeTestTimer.setHidden(false)
        
        startTimerLabel.setHidden(true)
        
        plusOneLabel.setHidden(true)
    }
    
    private func showNewShape(){
        plusOneLabel.setHidden(true)
        
        // 0 = 0
        previousShapeIndex = currentShapeIndex
        
        // newShapeIndex  = random from 0,1,2 index
        var newShapeIndex = pickNewShapeIndex()
        
        //Avoid repeating the same shape more than once:
        while currentShapeIsRepeat && newShapeIndex == currentShapeIndex {
            newShapeIndex = pickNewShapeIndex()
        }
        
        currentShapeIndex = newShapeIndex
        currentShapeIsRepeat = currentShapeIndex == previousShapeIndex //true
        updateShapeViewToCurrent()
        
        currentShapeStartTime = Date()
        print(currentShapeStartTime)
    }
    
    //function to get random images
    private func getImage() {
        let randomImage = images.randomElement()
        let currentImage = UIImage(named: "\(randomImage!)")
        
        shapeTestImage.setImage(currentImage)
    }
    
    
    //Bryans code
    //gets random index for the next image
    private func pickNewShapeIndex() -> Int {
        return Int(arc4random_uniform(UInt32(Constants.numberShapeTestShapes)))
        
    }
    
    private func updateShapeViewToCurrent() {
        if shapeTestImage != nil{
            shapeTestImage.setImage(UIImage(named: currentShapeName))
            shapeTestImage.setHidden(false)
        }
    }
    
    @IBAction func yesButtonPressed() {
        handleButtonPress(answerIsForSameShape: true)
        //getImage()
    }
    
    @IBAction func noButtonPressed() {
        handleButtonPress(answerIsForSameShape: false)
        //getImage()
    }
    
    private func handleButtonPress(answerIsForSameShape: Bool) {

        
        let currentShapeSameAsPrevious = currentShapeIndex == previousShapeIndex
        let answerIsCorrect = currentShapeSameAsPrevious ? answerIsForSameShape : !answerIsForSameShape
           
        let shapeEndTime = Date()
        let shapeReactionTime = shapeEndTime.timeIntervalSince(currentShapeStartTime)
           
        //score will be 1(points) if 'answerIsCorrect' is true, 0 if answer is not correct.
        let score = answerIsCorrect ? 1 : 0
        print("current point made: \(score)")
    
        currentScore += score
        
        if score == 1 {
            plusOneLabel.setHidden(false)
        }
        
        
        //addShapeResult(reactionTime: Float, shapeName: String, previousShapeName: String, score: Int)
        shapeTestPrompt.addShapeResult(reactionTime: Float(shapeReactionTime), shapeName: currentShapeName, previousShapeName: previousShapeName, score: score)
           
        shapeTestImage.setHidden(true)
           
        //async lets the calling queue move on without waiting until the dispatched block is executed
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.shapeTestShowDelay, execute: {
            self.showNewShape()
        })
    }
       
    /*
    @IBAction func DoneBtnTapped() {
        print("Done with Shape Test")
        print("Current Score: \(currentScore)")
        //pushController(withName: "Current Results", context: "\(currentScore)")
    }*/
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        print("Current Score: \(currentScore)")
        if segueIdentifier == "toCurrentResults" {
            return "\(currentScore)"
        }
        return nil
    }
    
    private func finishTest() {
        
        /*
        if TestSecondsLeft != nil {
            shapeTestPrompt.completedDuration = shapeTestPrompt.duration - mainTimerSecondsLeft!
            shapeTestPrompt.finishedTime = Date()
        }
          
        dismiss()*/
 
    }
    
    
    
    

}
