//
//  Item.swift
//  Todoey
//
//  Created by Michael Flowers on 12/12/18.
//  Copyright © 2018 Michael Flowers. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var dateCreated : Date?
    
    //backward or inverse relationship it links each item back to a parent Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //Item can have more than one parentCategory
}
