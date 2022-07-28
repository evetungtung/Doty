//
//  NC2App.swift
//  NC2
//
//  Created by Evelin Evelin on 19/07/22.
//

import SwiftUI

@main
struct NC2App: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = CoreDataManager.shared
    

    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }.onChange(of: scenePhase) { _ in
            persistenceController.saveContext()
        }
    }
}
