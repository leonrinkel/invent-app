//
//  InventApp.swift
//  Invent
//
//  Created by Leon Rinkel on 13.08.23.
//

import SwiftUI

@main
struct InventApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
