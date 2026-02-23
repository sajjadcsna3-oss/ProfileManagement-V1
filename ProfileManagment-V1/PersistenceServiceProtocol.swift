import SwiftData
import UIKit

final class PersistenceService: PersistenceServiceProtocol {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchProfile() throws -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>()
        return try context.fetch(descriptor).first
    }
    
    func createProfileIfNeeded() throws -> UserProfile {
        if let existing = try fetchProfile() {
            return existing
        }
        
        let profile = UserProfile(
            fullName: "",
            email: "user@email.com",
            phone: ""
        )
        
        context.insert(profile)
        try context.save()
        return profile
    }
    
    func updateProfile(
        fullName: String,
        phone: String,
        image: UIImage?
    ) throws {
        
        let profile = try createProfileIfNeeded()
        
        profile.fullName = fullName
        profile.phone = phone
        
        if let image {
            profile.imageData = image.jpegData(compressionQuality: 0.8)
        }
        
        try context.save()
    }
}

protocol PersistenceServiceProtocol {
    func fetchProfile() throws -> UserProfile?
    func createProfileIfNeeded() throws -> UserProfile
    func updateProfile(
        fullName: String,
        phone: String,
        image: UIImage?
    ) throws
}
