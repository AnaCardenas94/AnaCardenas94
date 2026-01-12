//
//  Login.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 03/11/25.
//
import SwiftUI
import SwiftData
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FBSDKLoginKit
import FirebaseCore

struct LoginView: View {

    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]

    @State private var password: String = ""
    @State private var email: String = ""
    @State private var rememberMe: Bool = false
    @State private var errorMessage: String? = nil
    @State private var loggedIn: Bool = false
    @State private var userEmail: String = ""
    @State private var showingFacebookAlert = false
    @State private var facebookAlertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text("Login your account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .padding(.horizontal)

                SecureField("Enter your password", text: $password)
                    .textContentType(.password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .padding(.horizontal)
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, -10)
                }
                HStack {
                    Button(action: {
                        rememberMe.toggle()
                    }) {
                        HStack {
                            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                .foregroundColor(rememberMe ? Color(red: 0.06, green: 0.27, blue: 0.39) : .gray)
                                .font(.title3)
                            
                            Text("Remember me")
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot password?")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.06, green: 0.27, blue: 0.39))
                            .underline()
                    }
                }
                .padding(.horizontal)
                Button(action: loginUser) {
                    Text("Login")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.06, green: 0.27, blue: 0.39))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .navigationDestination(isPresented: $loggedIn) {
                    HomeView(userEmail: userEmail)
                }
                .onAppear { getRememberedEmail() }
                VStack(spacing: 16) {

                    Text("- Or sign in with -")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .padding(.top, 10)

                    HStack(spacing: 20) {
                        
                        Button(action: handleGoogleSignIn) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 60, height: 55)
                                .overlay(
                                    Image("google_icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 26, height: 26)
                                )
                        }
                        
                        Button(action: handleFacebookSignIn) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 60, height: 55)
                                .overlay(
                                    Image("facebook_icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 26, height: 26)
                                )
                        }
                    }
                    .padding(.top, 5)
                }
                .padding(.horizontal)
                HStack(spacing: 4) {
                    Text("New user?")
                        .foregroundColor(Color(red: 0.06, green: 0.27, blue: 0.39))
                    
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Sign Up")
                            .foregroundColor(Color(red: 0.06, green: 0.27, blue: 0.39))
                            .fontWeight(.semibold)
                            .underline()
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .alert(isPresented: $showingFacebookAlert) {
                Alert(
                    title: Text("Feature Unavailable"),
                    message: Text(facebookAlertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func loginUser() {
        guard !email.isEmpty else {
            errorMessage = "Enter your email"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Enter your password"
            return
        }
        
        if !EmailValidator.isValidEmail(email) {
            errorMessage = "Invalid email format"
            return
        }
        
        if let user = users.first(where: {
            $0.email.lowercased() == email.lowercased() &&
            $0.password == password
        }) {
            errorMessage = nil
            
            userEmail = user.email
            
            if rememberMe {
                UserDefaults.standard.set(user.email, forKey: "loggedInEmail")
            }
            
            loggedIn = true
        } else {
            errorMessage = "Incorrect email or password"
        }
    }
    
    
    private func getRememberedEmail() {
        if let savedEmail = UserDefaults.standard.string(forKey: "loggedInEmail") {
            email = savedEmail
            rememberMe = true
        }
    }
    
    private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("ERROR: No hay clientID en Firebase config")
            return
        }

        _ = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            print("ERROR: No se pudo obtener rootViewController")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("Error en Google Sign-In:", error.localizedDescription)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("No se obtuvo usuario o idToken")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, firebaseError in
                if let firebaseError = firebaseError {
                    print("Error al autenticar con Firebase:", firebaseError.localizedDescription)
                    errorMessage = "Google login failed"
                    return
                }
                errorMessage = nil
                userEmail = authResult?.user.email ?? "Unknown"
                loggedIn = true
                
                if let firebaseUser = authResult?.user {
                    let email = firebaseUser.email ?? ""
                    let name = firebaseUser.displayName ?? ""
                    self.saveUserToSwiftData(email: email, name: name)
                    self.userEmail = email
                    self.loggedIn = true
                }
                print("Google Login correcto: \(userEmail)")
            }
        }
    }
    
    private func handleFacebookSignIn() {
        self.facebookAlertMessage = "Facebook login is not implemented yet."
        self.showingFacebookAlert = true
    }
    
    private func saveUserToSwiftData(email: String, name: String) {
        if users.contains(where: { $0.email == email }) {
            print("El usuario \(email) ya existe en SwiftData.")
            return
        }

        let newUser = User(
            email: email,
            nombreCompleto: name,
            password: "",
            foto: nil
        )
        
        modelContext.insert(newUser)
        
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar el usuario en SwiftData: \(error.localizedDescription)")
        }
    }
}



#Preview {
    LoginView()
        .modelContainer(for: [User.self], inMemory: true)
}
