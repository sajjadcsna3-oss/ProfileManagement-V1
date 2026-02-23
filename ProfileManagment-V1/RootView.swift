import SwiftUI
import SwiftData

struct RootView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var environment = AppEnvironment(context: nil)
    
    var body: some View {
        NavigationStack(path: $environment.router.path) {
            SplashView()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView()
                        
                    case .profile:
                        if let persistence = environment.persistenceService {
                            let vm = ProfileViewModel(
                                persistence: persistence,
                                router: environment.router
                            )
                            ProfileView(viewModel: vm)
                        }
                        
                    case .editProfile:
                        if let persistence = environment.persistenceService {
                            let vm = EditProfileViewModel(
                                persistence: persistence,
                                router: environment.router
                            )
                            EditProfileView(viewModel: vm)
                        }
                    }
                }
        }
        .environmentObject(environment)
        .onAppear {
            environment.setupContext(context)
        }
    }
}
