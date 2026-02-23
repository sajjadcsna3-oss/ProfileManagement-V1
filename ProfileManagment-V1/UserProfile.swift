import SwiftData
import Foundation

@Model
final class UserProfile {
    
    var fullName: String
    var email: String
    var phone: String
    var imageData: Data?
    
    init(
        fullName: String,
        email: String,
        phone: String,
        imageData: Data? = nil
    ) {
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.imageData = imageData
    }
}
