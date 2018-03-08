//
//  Item.swift
//  Todooey
//
//  Created by Andy Harris on 07/03/2018.
//  Copyright © 2018 Andy Harris. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //new property, date, with a default of whatever the date is when the object is created
    @objc dynamic var dateCreated: Date?
    // define the inverse relationship to the "items" definition specified in Category class
    //parent category is of type Category for list of items
    //Link back to a Category object using its "items" property
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
