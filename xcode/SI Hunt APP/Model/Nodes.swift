//
//  Nodes.swift
//  ARKitImageRecognition
//
//  Created by Apple on 3/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Nodes {
    
    //MARK: Properties
    
    var id: Int
    var building: String
    var level: Int
    var pos_x: Int
    var pos_y: Int
    var default_exit_direction: Int
    var location_id: Int
    var location_name: String
    
    //MARK: Initialization
    
    init?(id: Int, building: String, level: Int, pos_x: Int, pos_y: Int, default_exit_direction: Int, location_id: Int, location_name: String){
        
        if building.isEmpty {
            return nil
        }
        if location_name.isEmpty {
            return nil
        }
        self.id = id
        self.building = building
        self.level = level
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.default_exit_direction = default_exit_direction
        self.location_id = location_id
        self.location_name = location_name
    }
    
}
