import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var environment: AppEnvironment
    @State private var isNavigated = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard !isNavigated else { return }
                isNavigated = true
                environment.router.push(.home)
            }
        }
    }
}
