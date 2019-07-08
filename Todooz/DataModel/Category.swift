//
//  Category.swift
//  Todooz
//
//  Created by adam on 06/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var bgColor: String = UIColor.randomFlat.hexValue()
    // Set up a Forvard Relationship with Items
    // List is the container type in Realm used to define to-many relationships.
    let items = List<Item>()
}
