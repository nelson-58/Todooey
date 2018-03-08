//
//  Category.swift
//  Todooey
//
//  Created by Andy Harris on 07/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // set up a relationship to the Item class. 1:many
    var items = List<Item>()
    //an array of type List of  Item objects
    //similar in principle to construct let array = Array<Int>() which can be written
    //let array : [Int]()
}
