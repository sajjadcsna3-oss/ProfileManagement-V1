import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var environment: AppEnvironment
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            Text("Profile Management")
                .font(.system(size: 20, weight: .semibold))
            
            Button {
                environment.router.push(.profile)
            } label: {
                Text("Go to Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}
