//
//  RunShapeTestInterfaceController.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana Rodríguez on 6/22/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import WatchKit
import Foundation


class RunShapeTestInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var startTimerLabel: WKInterfaceLabel!
    private var startSecondsLeft: Int = 3
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @objc func timerTick(){
        startSecondsLeft -= 1
        startTimerLabel?.setText("\(startSecondsLeft)")
    }

}
