import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    private let persistence: PersistenceServiceProtocol
    private let router: AppRouter
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var image: UIImage?
    
    @Published var loadingState: LoadingState = .idle
    
    init(persistence: PersistenceServiceProtocol, router: AppRouter) {
        self.persistence = persistence
        self.router = router
    }
    
    func loadProfile() {
        loadingState = .loading
        
        do {
            let profile = try persistence.createProfileIfNeeded()
            
            fullName = profile.fullName
            email = profile.email
            phone = profile.phone
            
            if let data = profile.imageData {
                image = UIImage(data: data)
            }
            
            loadingState = .success
            
        } catch {
            loadingState = .failure("Failed to load profile")
        }
    }
    
    func goToEdit() {
        router.push(.editProfile)
    }
}
