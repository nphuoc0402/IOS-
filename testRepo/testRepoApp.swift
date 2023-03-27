//
//  testRepoApp.swift
//  testRepo
//
//  Created by tester on 2023/03/27.
//

import SwiftUI

@main
struct testRepoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
