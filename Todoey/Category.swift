//
//  Category.swift
//  Todoey
//
//  Created by Michael Flowers on 12/12/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object { //super class is Object of Realm
    @objc dynamic var name : String = ""
    
    //forward realtionship each category can have mulitple items
    let items = List<Item>() //RealmSwift's version of an array
}
