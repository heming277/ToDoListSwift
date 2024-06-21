//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by Heming Liu on 2024-06-20.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
