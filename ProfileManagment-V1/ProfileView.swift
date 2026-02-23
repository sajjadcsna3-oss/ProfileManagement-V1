import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            if viewModel.loadingState == .loading {
                ProgressView()
            }
            
            Spacer().frame(height: 20)
            
            Group {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            VStack(spacing: 14) {
                infoRow(title: "Full Name", value: viewModel.fullName)
                infoRow(title: "Email", value: viewModel.email)
                infoRow(title: "Phone", value: viewModel.phone)
            }
            .padding()
            .background(Color.gray.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            Button {
                viewModel.goToEdit()
            } label: {
                Text("Edit Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProfile()
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
}
