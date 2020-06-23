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
    
    
    @IBOutlet weak var shapeTestImage: WKInterfaceImage!
    @IBOutlet weak var shapeTestTimer: WKInterfaceTimer!
    @IBOutlet weak var startTimerLabel: WKInterfaceLabel!
    
    
    private var startSecondsLeft: Int = 3
    private var timer: Timer?
    
    
    
    @IBOutlet weak var yesButton: WKInterfaceButton!
    @IBOutlet weak var noButton: WKInterfaceButton!
    
    
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
        setTimerLabels()
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
    }
    
    private func setTimerLabels() {
        startTimerLabel?.setText("\(startSecondsLeft)")
    }

    //when countdown is 0 and we actually start running the test
    
    private func switchToMainTest() {
        shapeTestTimer.setDate(NSDate(timeIntervalSinceNow:  46) as Date)
        shapeTestTimer.start()
        
        showTestView()
    }
    
    
    private func showStartView(){
        shapeTestImage.setHidden(true)
        yesButton.setHidden(true)
        noButton.setHidden(true)
        
        startTimerLabel.setHidden(false)
        
        
    }
    private func showTestView(){
        startTimerLabel.setHidden(true)
        
        shapeTestImage.setHidden(false)
        yesButton.setHidden(false)
        noButton.setHidden(false)
    }
}
