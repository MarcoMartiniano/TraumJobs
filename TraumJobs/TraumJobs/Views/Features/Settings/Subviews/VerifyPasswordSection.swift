//
//  VerifyPasswordSection.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

// MARK: - Verify Password Section
struct VerifyPasswordSection: View {
    
    @Binding var currentPassword: String
    var onVerify: () -> Void
    
    @State var showPassword = false
    
    var body: some View {
        Section(header: Text("Passwort eingeben, um zu speichern")) {
            
            HStack {
                
                if showPassword {
                    TextField("Aktuelles Passwort eingeben, um zu speichern", text: $currentPassword)
                } else {
                    SecureField("Aktuelles Passwort eingeben, um zu speichern", text: $currentPassword)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? AppIcons.eyeSlash : AppIcons.eye)
                        .foregroundColor(.gray)
                }
            }
            
            Button("Passwort prüfen") {
                onVerify()
            }
        }
    }
}

#Preview {
    VerifyPasswordSection(
        currentPassword: .constant("password"),
        onVerify: {},
        showPassword: true
        )
}
