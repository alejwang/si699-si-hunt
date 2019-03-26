//
//  Tag.swift
//
//  Created by Zhen Wang on 3/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Tag {
    
    // MARK: Properties
    // ****************************************************************
    
    var id: Int
    var name: String
    var priority: Int
    
    
    // MARK: Initialization
    // ****************************************************************
    
    init?(id: Int, name: String, priority: Int){
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.id = id
        self.priority = priority
    }
    
    var description: String {
        return "<\(type(of: self)): \(id) - \(name) - p\(priority)>"
    }
}
