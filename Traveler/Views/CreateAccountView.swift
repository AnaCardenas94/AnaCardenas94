//
//  CreateAccount.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 14/11/25.
//
import SwiftUI
import PhotosUI
import SwiftData

struct CreateAccountView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query var users: [User]

    @State private var profileImage: UIImage? = nil
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var success: Bool = false
    @State private var error: Bool = false
    

    var body: some View {
        VStack(spacing: 30) {
            Text("Create user")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
            VStack {
                if let profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 5)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
                
                PhotosPicker(
                    selection: $selectedPhoto,
                    matching: .images
                ) {
                    Text("Select photo")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.06, green: 0.27, blue: 0.39))
                        .underline()
                }
            }
            .task(id: selectedPhoto) {
                guard let item = selectedPhoto else { return }
                
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = uiImage
                }
            }
            
            Group {
                TextField("FullName", text: $fullname)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray))
            }
            .padding(.horizontal)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: {
                crearUsuario()
            }) {
                Text("Create user")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.06, green: 0.27, blue: 0.39))
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .padding(.top, 40)
        .alert("Account created", isPresented: $success) {
            Button("Ok", role: .cancel) {
                dismiss()
            }
        }
        .alert("ALERTA",
            isPresented: $error) {
            Button("Ok") {
                cleanFields()
            }
        } message: {
            if let message = errorMessage {
                Text(message)
            } else {
                Text("An unknown error occurred.")
            }
        }
    }
    
    private func crearUsuario() {
        guard !fullname.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The fullname is required"
            return
        }
        guard !email.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The email is required"
            return
        }
        
        guard EmailValidator.isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }
        
        guard !password.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The password is required"
            return
        }
        
        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            errorMessage = "This email is already registered"
            return
        }

        if users.contains(where: { $0.nombreCompleto.lowercased() == fullname.lowercased() }) {
            errorMessage = "This name is already in use"
            return
        }
        
        let fotoData = profileImage?.jpegData(compressionQuality: 0.8)
        
        let newUser = User(
            email: email,
            nombreCompleto: fullname,
            password: password,
            foto: fotoData
        )
        
        context.insert(newUser)
        
        do {
            try context.save()
            success = true
            errorMessage = nil
        } catch {
            errorMessage = "Error saving user"
        }
    }
    
    private func cleanFields() {
        fullname = ""
        email = ""
        password = ""
        profileImage = nil
        selectedPhoto = nil
        errorMessage = nil
    }
}

#Preview {
    CreateAccountView()
        .modelContainer(for: [User.self], inMemory: true)
}
