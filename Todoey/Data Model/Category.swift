//
//  Category.swift
//  Todoey
//
//  Created by Jésus Husbands on 25/05/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
