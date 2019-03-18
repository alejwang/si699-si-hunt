//
//  Event.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 2/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

//class Event {
//
//    //MARK: Properties
//
//    var name: String
//    var time: String
//    var location: String
//
//    //MARK: Initialization
//
//    init?(name: String, time: String, location: String){
//        if name.isEmpty {
//            return nil
//        }
//
//        self.name = name
//        self.time = time
//        self.location = location
//    }
//
//}

class Event {
    
    //MARK: Properties
    
    var name: String
    var description: String
    var capacity: Int
    var organizer_id: Int
    var organizer_name: String
    var start_time: String
    var end_time: String
    var location_id: Int
    var location_name: String
    var location_is_armap_available: Bool
    var is_published: Bool
    var pub_date: String
    
    //MARK: Initialization
    
    init?(name: String, description: String, capacity: Int, organizer_id: Int, organizer_name: String, start_time: String, end_time: String, location_id: Int, location_name: String, location_is_armap_available: Bool, is_published: Bool, pub_date: String){
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.description = description
        self.capacity = capacity
        self.organizer_id = organizer_id
        self.organizer_name = organizer_name
        self.start_time = start_time
        self.end_time = end_time
        self.location_id = location_id
        self.location_name = location_name
        self.location_is_armap_available = location_is_armap_available
        self.is_published = is_published
        self.pub_date = pub_date
    }
    
}
