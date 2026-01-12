//
//  Settings.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 14/11/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct SettingsView: View {
    
    @Query var users: [User]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil
    @State private var goToLogin = false
    @State private var defaultFrom: String = UserDefaults.standard.string(forKey: "defaultFrom") ?? "MXN"
    @State private var defaultTo: String = UserDefaults.standard.string(forKey: "defaultTo") ?? "USD"
    @State private var defaultAmount: Double = UserDefaults.standard.double(forKey: "defaultAmount") == 0 ? 1 : UserDefaults.standard.double(forKey: "defaultAmount")
    
    let userEmail: String
    let currencies = [
        ("🇺🇸", "USD"), ("🇲🇽", "MXN"), ("🇯🇵", "JPY"),
        ("🇪🇺", "EUR"), ("🇰🇷", "KRW")
    ]
    
    var currentUser: User? {
        users.first(where: { $0.email.lowercased() == userEmail.lowercased() })
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                // MARK: - PERFIL
                Section(header: Text("Profile")) {
                    HStack(spacing: 20) {
                        ZStack {
                            if let profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else if let data = currentUser?.foto,
                                      let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                    )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.nombreCompleto ?? "")
                                .font(.headline)
                            Text(currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Change photo")
                            .underline()
                            .tint(Color(red: 0.06, green: 0.27, blue: 0.39))
                    }
                }
                .task(id: selectedPhoto) {
                    guard let item = selectedPhoto else { return }
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data),
                       let user = currentUser {
                        profileImage = uiImage
                        user.foto = data
                        try? context.save()
                    }
                }
                Section(header: Text("Currency Preferences")) {
                    
                    Picker("From Currency", selection: $defaultFrom) {
                        ForEach(currencies, id: \.1) {
                            Text("\($0.0) \($0.1)").tag($0.1)
                        }
                    }
                    
                    Picker("To Currency", selection: $defaultTo) {
                        ForEach(currencies, id: \.1) {
                            Text("\($0.0) \($0.1)").tag($0.1)
                        }
                    }
                    
                    Stepper("Default Amount \(Int(defaultAmount))",
                            value: $defaultAmount,
                            in: 1...1000)
                }
                .onChange(of: defaultFrom) { savePreferences() }
                .onChange(of: defaultTo) { savePreferences() }
                .onChange(of: defaultAmount) { savePreferences() }
                Section {
                    Button(role: .destructive) {
                        logout()
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            .navigationTitle("")
            .navigationDestination(isPresented: $goToLogin) {
                LoginView()
            }
        }
        .onAppear { loadImageIfExists() }
    }
    
    private func savePreferences() {
        UserDefaults.standard.set(defaultFrom, forKey: "defaultFrom")
        UserDefaults.standard.set(defaultTo, forKey: "defaultTo")
        UserDefaults.standard.set(defaultAmount, forKey: "defaultAmount")
    }
    
    private func loadImageIfExists() {
        if let data = currentUser?.foto,
           let uiImage = UIImage(data: data) {
            profileImage = uiImage
        }
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInEmail")
        UserDefaults.standard.removeObject(forKey: "rememberMe")
        goToLogin = true
    }
}
