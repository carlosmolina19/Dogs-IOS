import SwiftUI

@main
struct Dogs_IOSApp: App {
    let persistence = Persistence.shared

    var body: some Scene {
        WindowGroup {
            DogsSceneBuilder().build(persistentContainer: persistence.persistentContainer)
        }
    }
}
