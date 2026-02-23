import SwiftUI
import SwiftData

@main
struct ProfileManagement_V1App: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
