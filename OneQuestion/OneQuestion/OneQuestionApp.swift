//
//  OneQuestionApp.swift
//  OneQuestion
//
//  Created by Tristan Stenuit on 06/06/2023.
//

import SwiftUI

@main
struct OneQuestionApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
