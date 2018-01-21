//
//  Category.swift
//  Todoey
//
//  Created by Bhavna Mohan on 14/01/18.
//  Copyright © 2018 Bhavna Mohan. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object
{
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
