//
//  Navnode.swift
//  ARKitImageRecognition
//
//  Created by Apple on 3/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class Navpath {
    
    //MARK: Properties
    
    var node_to_id: Int
    var distance: Int
    var direction_2d: Int
    var to_level: Int
    var default_exit_direction: Int
    var node_to_special_type: String
    var to_floor: Int
    
    //MARK: Initialization
    
    init?(node_to_id: Int, distance: Int, direction_2d: Int, to_level: Int, default_exit_direction: Int, node_to_special_type: String, to_floor: Int){
        if node_to_special_type.isEmpty {
            return nil
        }
        
        self.node_to_id = node_to_id
        self.distance = distance
        self.direction_2d = direction_2d
        self.to_level = to_level
        self.default_exit_direction = default_exit_direction
        self.node_to_special_type = node_to_special_type
        self.to_floor = to_floor
    }
    
}
