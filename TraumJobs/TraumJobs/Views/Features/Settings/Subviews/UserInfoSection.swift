//
//  UserInfoSection.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

// MARK: - User Info Section
struct UserInfoSection: View {
    
    @Binding var name: String
    @Binding var email: String
    @Binding var city: String
    @Binding var birthDate: Date?
    
    var body: some View {
        Section(header: Text("Benutzerinformationen")) {
            
            TextField("Name", text: $name)
            TextField("E-Mail", text: $email)
            TextField("Stadt", text: $city)
            
            // Date picker for selecting the birth date
            DatePicker(
                "Geburtsdatum",
                selection: Binding(
                    get: { birthDate ?? Date() },
                    set: { birthDate = $0 }
                ),
                displayedComponents: .date
            )
        }
    }
}

#Preview {
    let user = UserPreviewData.user
    UserInfoSection(
        name: .constant(user.name),
        email: .constant(user.email),
        city: .constant(user.city),
        birthDate: .constant(user.birthDate),
    )
}
