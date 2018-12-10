//
//  File.swift
//  Todoey
//
//  Created by Michael Flowers on 12/10/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import Foundation

class Item {
    let title : String
    var isDone : Bool
    
    init(title: String , isDone: Bool = false) {
        self.title = title
        self.isDone = isDone
        
    }
}
