//
//  SignUpView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    var onRegisterSuccess: ((String, String) -> Void)?
    
    // MARK: - Form fields
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    // MARK: - Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Persönliche Informationen")) {
                    
                    TextField("Name", text: $name)
                    
                    TextField("E-Mail", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    SecureField("Passwort", text: $password)
                }
            }
            .navigationTitle("Registrieren")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Registrieren") {
                        registerUser()
                    }
                    .disabled(
                        name.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty
                    )
                }
            }
            .alert("Hinweis", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func registerUser() {
        
        // Normalize email by trimming whitespace and converting to lowercase
        let trimmedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        // Prevent registration using the reserved guest email
        guard trimmedEmail != "guest@traumjobs.local" else {
            alertMessage = "Diese E-Mail ist reserviert."
            showAlert = true
            return
        }
        
        // Validate email format before proceeding
        guard ValidationHelper.isValidEmail(trimmedEmail) else {
            alertMessage = "Bitte geben Sie eine gültige E-Mail-Adresse ein."
            showAlert = true
            return
        }
        
        // Check if a user with this email already exists in the database
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate { $0.email == trimmedEmail }
        )
        
        do {
            let existingUsers = try context.fetch(descriptor)
            
            // Prevent duplicate email registration
            if !existingUsers.isEmpty {
                alertMessage = "Ein Benutzer mit dieser E-Mail existiert bereits."
                showAlert = true
                return
            }
            
            // Create new user instance
            let newUser = User(
                name: name,
                password: password,
                email: trimmedEmail,
                birthDate: nil,
                city: ""
            )
            
            // Insert and persist the new user
            context.insert(newUser)
            try context.save()
            
            // Trigger success callback and close registration view
            onRegisterSuccess?(trimmedEmail, password)
            dismiss()
            
        } catch {
            // Handle database fetch errors
            alertMessage = "Fehler beim Überprüfen der E-Mail."
            showAlert = true
        }
    }
}

#Preview {
    SignUpView()
}
