//
//  Data.swift
//  Todoey
//
//  Created by Jésus Husbands on 25/05/2019.
//  Copyright © 2019 TeamJSus. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object{
    // Properties using realm swift
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
