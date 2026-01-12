//
//  Profile.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 14/11/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ProfileView: View {
    
    @Environment(\.modelContext) private var context
    @Query var users: [User]
    
    @State private var profileImage: UIImage? = nil
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var msgSaved = false
    @State private var errorMessage: String? = nil
    
    var userEmail: String
    var currentUser: User? {
        users.first(where: { $0.email.lowercased() == userEmail.lowercased() })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 35) {
                Text("User Profile")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                VStack(spacing: 12) {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .shadow(radius: 5)
                        
                    } else if let data = currentUser?.foto,
                              let img = UIImage(data: data) {
                        
                        Image(uiImage: img)
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
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        Text("Change Photo")
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
                VStack(spacing: 20) {
                    CustomInputField(title: "Full Name", text: $fullname)
                    CustomInputField(title: "Email", text: $email, keyboard: .emailAddress)
                    CustomInputField(title: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.06, green: 0.27, blue: 0.39))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .onAppear(perform: loadUserData)
        .alert("Saved Changes", isPresented: $msgSaved) {
            Button("OK", role: .cancel) { }
        }
    }
    
    
    private func loadUserData() {
        guard let user = currentUser else { return }
        fullname = user.nombreCompleto
        email = user.email
        password = user.password
        
        if let data = user.foto,
           let img = UIImage(data: data) {
            profileImage = img
        }
    }
    
    
    private func saveChanges() {
        guard let user = currentUser else {
            errorMessage = "User not found"
            return
        }
        
        guard !fullname.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The fullname is required"
            return
        }
        guard !email.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The email is required"
            return
        }
        
        guard !password.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The password is required"
            return
        }
        
        guard EmailValidator.isValidEmail(email) else {
            errorMessage = "Invalid email"
            return
        }
        
        if let img = profileImage {
            user.foto = img.jpegData(compressionQuality: 0.85)
        }
        
        user.nombreCompleto = fullname
        user.email = email
        user.password = password
        
        if UserDefaults.standard.bool(forKey: "rememberMe") {
            UserDefaults.standard.set(email, forKey: "loggedInEmail")
        }
        
        do {
            try context.save()
            msgSaved = true
            errorMessage = nil
        } catch {
            errorMessage = "Error saving changes"
        }
    }
}

struct CustomInputField: View {
    var title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(.gray))
            } else {
                TextField(title, text: $text)
                    .keyboardType(keyboard)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 6).stroke(.gray))
            }
        }
    }
}

#Preview {
    ProfileView(userEmail: "test@example.com")
        .modelContainer(for: [User.self], inMemory: true)
}
