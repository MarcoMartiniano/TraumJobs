//
//  ChangePasswordSection.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

// MARK: - Change Password Section
struct ChangePasswordSection: View {
    
    @Binding var newPassword: String
    @State var showPassword = false
    
    var body: some View {
        Section(header: Text("Passwort ändern (optional)")) {
            
            HStack {
                
                if showPassword {
                    TextField("Neues Passwort", text: $newPassword)
                } else {
                    SecureField("Neues Passwort", text: $newPassword)
                }
                
                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? AppIcons.eyeSlash : AppIcons.eye)
                        .foregroundColor(.gray)
                }
            }
            
            Text("Lassen Sie das Passwort leer, um es nicht zu ändern.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    ChangePasswordSection(
        newPassword: .constant("newpassword"),
        showPassword: true
    )
}
