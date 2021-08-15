//
//  HouseholdBillsApp.swift
//  Shared
//
//  Created by Pablo Albella on 8/15/21.
//

import SwiftUI

@main
struct HouseholdBillsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
