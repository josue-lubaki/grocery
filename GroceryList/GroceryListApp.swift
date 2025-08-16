//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Josue Lubaki on 2025-08-16.
//

import SwiftUI
import SwiftData

@main
struct GroceryListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
