import SwiftUI
import PhotosUI

struct EditProfileView: View {

    @ObservedObject var viewModel: EditProfileViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var showCamera = false
    
    // ✅ Wrapper instead of UIImage
    @State private var cropperItem: CropperItem?

    var body: some View {
        VStack(spacing: 20) {
            
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: Profile Image
                    
                    VStack(spacing: 16) {
                        
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

                        // MARK: Gallery + Camera Buttons
                        
                        HStack(spacing: 12) {

                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("Gallery")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 1.5)
                                    )
                            }

                            Button {
                                showCamera = true
                            } label: {
                                Text("Take Photo")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 1.5)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: Form
                    
                    VStack(spacing: 16) {

                        TextField("Full Name", text: $viewModel.fullName)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: viewModel.fullName) { _ in
                                viewModel.validate()
                            }

                        if !viewModel.fullNameError.isEmpty {
                            Text(viewModel.fullNameError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(.roundedBorder)
                            .disabled(true)

                        TextField("Phone", text: $viewModel.phone)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: viewModel.phone) { _ in
                                viewModel.validate()
                            }

                        if !viewModel.phoneError.isEmpty {
                            Text(viewModel.phoneError)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        if viewModel.loadingState == .loading {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Button("Save") {
                viewModel.save()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            .disabled(!viewModel.isValid)
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    viewModel.cancel()
                }
            }
        }

        // MARK: Gallery Selection
        .onChange(of: selectedItem) { _, newItem in
            viewModel.handleGallerySelection(newItem) { image in
                cropperItem = CropperItem(image: image)
            }
        }

        // MARK: Camera Sheet
        .sheet(isPresented: $showCamera) {
            CameraPicker { image in
                cropperItem = CropperItem(image: image)
            }
        }

        // MARK: Cropper Sheet (Fixed)
        .sheet(item: $cropperItem) { item in
            ImageCropperView(image: item.image) { cropped in
                viewModel.image = cropped
                cropperItem = nil
            }
        }
    }
}


// ✅ Identifiable Wrapper
struct CropperItem: Identifiable {
    let id = UUID()
    let image: UIImage
}
