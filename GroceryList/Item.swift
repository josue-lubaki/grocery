//
//  Item.swift
//  GroceryList
//
//  Created by Josue Lubaki on 2025-08-16.
//


import Foundation
import SwiftData

@Model
class Item {
    var title : String
    var isCompleted : Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
