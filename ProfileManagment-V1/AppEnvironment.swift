import SwiftUI
import SwiftData
import Combine

final class AppEnvironment: ObservableObject {
    
    @Published var router: AppRouter
    var persistenceService: PersistenceServiceProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(context: ModelContext?) {
        router = AppRouter()
        
        router.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        if let context {
            persistenceService = PersistenceService(context: context)
        }
    }
    
    func setupContext(_ context: ModelContext) {
        persistenceService = PersistenceService(context: context)
    }
}
