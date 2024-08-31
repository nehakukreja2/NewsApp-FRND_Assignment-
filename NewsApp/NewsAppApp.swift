//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Neha Kukreja on 31/08/24.
//

import SwiftUI

@main
struct NewsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
