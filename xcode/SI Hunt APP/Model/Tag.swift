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
    
    
    // MARK: Initialization
    // ****************************************************************
    
    init?(id: Int, name: String){
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.id = id
    }
}
