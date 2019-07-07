//
//  Item.swift
//  Todooz
//
//  Created by adam on 06/07/2019.
//  Copyright © 2019 Adam. All rights reserved.
//

import Foundation
import RealmSwift

// Object is a class used to define Realm model objects.
class Item: Object {
    // "dynamic" variables are being monitored by Realm for changes
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    // Set up Inverse Relationship with Categories
    // LinkingObjects is an auto-updating container type.
    // It represents zero or more objects that are linked to its owning model object through a property relationship.
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // note: Category.self is a "type" of category
}
