import SwiftUI
import Combine
import PhotosUI

@MainActor
final class EditProfileViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let persistence: PersistenceServiceProtocol
    private let router: AppRouter
    
    // MARK: - Published Properties
    
    @Published var fullName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var image: UIImage?
    
    @Published var fullNameError = ""
    @Published var phoneError = ""
    
    @Published var loadingState: LoadingState = .idle
    
    // MARK: - Validation State
    
    var isValid: Bool {
        fullNameError.isEmpty &&
        phoneError.isEmpty &&
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Init
    
    init(
        persistence: PersistenceServiceProtocol,
        router: AppRouter
    ) {
        self.persistence = persistence
        self.router = router
        loadInitial()
    }
    
    // MARK: - Load Initial Data
    
    private func loadInitial() {
        do {
            let profile = try persistence.createProfileIfNeeded()
            
            fullName = profile.fullName
            email = profile.email
            phone = profile.phone
            
            if let data = profile.imageData {
                image = UIImage(data: data)
            }
        } catch {
            loadingState = .failure("Failed to load profile")
        }
    }
    
    // MARK: - Validation
    
    func validate() {
        
        if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            fullNameError = "Full name required"
        } else {
            fullNameError = ""
        }
        
        let regex = "^[0-9]+$"
        if phone.isEmpty {
            phoneError = ""
        } else if phone.range(of: regex, options: .regularExpression) == nil {
            phoneError = "Phone must be numeric"
        } else {
            phoneError = ""
        }
    }
    
    // MARK: - Gallery Image Handling
    
    func handleGallerySelection(
        _ item: PhotosPickerItem?,
        completion: @escaping (UIImage) -> Void
    ) {
        guard let item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                
                await MainActor.run {
                    completion(uiImage)
                }
            }
        }
    }
    
    // MARK: - Camera Image Handling
    
    func handleCameraImage(
        _ image: UIImage,
        completion: @escaping (UIImage) -> Void
    ) {
        completion(image)
    }
    
    // MARK: - Save
    
    func save() {
        validate()
        guard isValid else { return }
        
        loadingState = .loading
        
        do {
            try persistence.updateProfile(
                fullName: fullName,
                phone: phone,
                image: image
            )
            
            loadingState = .success
            router.pop()
            
        } catch {
            loadingState = .failure("Save failed")
        }
    }
    
    // MARK: - Cancel
    
    func cancel() {
        router.pop()
    }
}
