//
//  Category.swift
//  Todoey
//
//  Created by Clayton Wallace on 2018-06-16.
//  Copyright © 2018 Clayton Wallace. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
