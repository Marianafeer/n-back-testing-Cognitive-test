//
//  ResultsInterfaceController.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 6/25/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import WatchKit
import Foundation


class ResultsInterfaceController: WKInterfaceController {

    @IBAction func okButtonPressed() {
        print("Ok button was pressed")
    
    }
    
    
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

}
