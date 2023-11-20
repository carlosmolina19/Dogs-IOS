//
//  Dogs_IOSApp.swift
//  Dogs-IOS
//
//  Created by Carlos Molina Sáenz on 20/11/23.
//

import SwiftUI

@main
struct Dogs_IOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
