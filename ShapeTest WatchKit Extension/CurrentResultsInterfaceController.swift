//
//  CurrentResultsInterfaceController.swift
//  ShapeTest WatchKit Extension
//
//  Created by Mariana on 7/3/20.
//  Copyright © 2020 Mariana. All rights reserved.
//

import WatchKit
import Foundation


class CurrentResultsInterfaceController: WKInterfaceController {

    @IBOutlet weak var scoreLabel: WKInterfaceLabel!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        if let results = context as? String {
            scoreLabel.setText("Score: \(results)")
        }
        
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
