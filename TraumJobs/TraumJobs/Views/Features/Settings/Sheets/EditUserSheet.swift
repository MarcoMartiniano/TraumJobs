//
//  EditUserSheet.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI
import SwiftData

// MARK: - Edit User Sheet
struct EditUserSheet: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var user: User
    
    // MARK: - State
    @State private var passwordVerified = false
    @State private var currentPassword = ""
    @State private var newPassword = ""
    
    @State private var name: String
    @State private var email: String
    @State private var city: String
    @State private var birthDate: Date?
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "Fehler"
    
    // MARK: - Initializer
    init(user: User) {
        self.user = user
        _name = State(initialValue: user.name)
        _email = State(initialValue: user.email)
        _city = State(initialValue: user.city)
        _birthDate = State(initialValue: user.birthDate)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                UserInfoSection(
                    name: $name,
                    email: $email,
                    city: $city,
                    birthDate: $birthDate
                )
                
                if user.email.lowercased() != "guest@traumjobs.local" {
                    ChangePasswordSection(newPassword: $newPassword)
                    
                    VerifyPasswordSection(
                        currentPassword: $currentPassword,
                        onVerify: verifyPassword
                    )
                }
                
                if user.email.lowercased() == "guest@traumjobs.local" || passwordVerified {
                    Section {
                        Button(action: saveChanges) {
                            Text("Speichern")
                                .frame(maxWidth: .infinity)
                                .bold()
                                .padding()
                                .foregroundStyle(Color.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        // Fade + slide animation
                        .transition(.opacity.combined(with: .slide))
                        .animation(.easeInOut(duration: 0.4), value: passwordVerified)
                    }
                }
            }
            .navigationTitle("Profil bearbeiten")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    // MARK: - Save Changes
    private func saveChanges() {
        
        // Trim whitespace to avoid accidental empty password updates
        let trimmedPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Prevent guest users from changing their password
        if user.email.lowercased() != "guest@traumjobs.local" {
            
            // Only update password if a new one was provided
            if !trimmedPassword.isEmpty {
                
                // Validate current password before updating
                guard currentPassword == user.password else {
                    alertTitle = "Fehler"
                    alertMessage = "Falsches Passwort. Änderungen nicht gespeichert."
                    showAlert = true
                    return
                }
                
                user.password = trimmedPassword
            }
        }
        
        // Update user profile data
        user.name = name
        user.email = email
        user.city = city
        user.birthDate = birthDate
        
        // Persist changes
        try? context.save()
        
        dismiss()
    }


    // MARK: - Verify Current Password
    private func verifyPassword() {
        
        // Compare entered password with stored password
        guard currentPassword == user.password else {
            alertTitle = "Fehler"
            alertMessage = "Falsches Passwort."
            showAlert = true
            passwordVerified = false
            return
        }

        passwordVerified = true
    }
}

#Preview {
    EditUserSheet(user: UserPreviewData.user)
        .modelContainer(
            for: [User.self],
            inMemory: true
        )
}
