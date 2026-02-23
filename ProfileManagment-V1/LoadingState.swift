import SwiftUI

enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
    
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.success, .success):
            return true
            
        case (.failure(let l), .failure(let r)):
            return l == r
            
        default:
            return false
        }
    }
}
