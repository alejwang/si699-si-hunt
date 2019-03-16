//
//  Event.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 2/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Event {
    
    //MARK: Properties
    
    var name: String
    var time: String
    var location: String
    
    //MARK: Initialization
    
    init?(name: String, time: String, location: String){
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.time = time
        self.location = location
    }
    
}
