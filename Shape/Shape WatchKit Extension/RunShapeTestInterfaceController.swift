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
    
    @IBOutlet weak var startCountdownLabel: WKInterfaceLabel!
    @IBOutlet weak var shapeImage: WKInterfaceImage!
    @IBOutlet weak var testTimer: WKInterfaceTimer!
    @IBOutlet weak var noButton: WKInterfaceButton!
    @IBOutlet weak var yesButton: WKInterfaceButton!
    
    
    private var startCountdown: Int = 3
    
    
    

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
        
        
    }
    
    //views
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
    
    @objc func showNewShape() {
        
    }
    
}
