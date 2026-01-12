//
//  ForgotPassword.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 14/11/25.
//

import SwiftUI
import SwiftData

struct ForgotPasswordView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query var users: [User]
    
    @State private var email: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var msgSaved = false
    @State private var errorMessage: String? = nil
    
    var currentUser: User? {
        users.first(where: { $0.email.lowercased() == email.lowercased() })
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Reset Password")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            Text("Enter your registered email and your new password")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            TextField("Enter your email", text: $email)
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
            
            SecureField("New password", text: $newPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
                .textContentType(.newPassword)
            
            SecureField("Confirm password", text: $confirmPassword)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
                .textContentType(.password)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: resetPassword) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text("Save New Password")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.06, green: 0.27, blue: 0.39))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .disabled(isLoading)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Saved Changes", isPresented: $msgSaved) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
    
    func resetPassword() {
        isLoading = true
        errorMessage = nil
        
        guard !email.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The fullname is required"
            return
        }
        
        guard let user = currentUser else {
            errorMessage = "User not found."
            isLoading = false
            return
        }
        
        if confirmPassword != newPassword {
            errorMessage = "Passwords do not match."
            isLoading = false
            return
        }
        
        if user.password == newPassword {
            errorMessage = "The new password must be different from the current password."
            isLoading = false
            return
        }
        
        user.password = confirmPassword
        
        do {
            try context.save()
            msgSaved = true
            cleanFields()
            
        } catch {
            errorMessage = "Error saving changes: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func cleanFields() {
        email = ""
        newPassword = ""
        confirmPassword = ""
    }
}

#Preview {
    ForgotPasswordView()
}
