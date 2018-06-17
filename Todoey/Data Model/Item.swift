//
//  Item.swift
//  Todoey
//
//  Created by Clayton Wallace on 2018-06-16.
//  Copyright © 2018 Clayton Wallace. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
