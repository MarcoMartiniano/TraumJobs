//
//  UserSectionView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

struct UserSectionView: View {
    
    let user: User?
    
    var body: some View {
        Section(header: Text("Benutzer")) {
            if let user {
                Text("Name: \(user.name)")
                Text("E-Mail: \(user.email)")
                Text("Stadt: \(user.city)")
                
                if let birthDate = user.birthDate {
                     Text("Geburtsdatum: \(birthDate.formatted(date: .long, time: .omitted))")
                 } else {
                     Text("Ihr Geburtsdatum fehlt – fügen Sie es hinzu!")
                         .font(.footnote)
                         .foregroundColor(.gray)
                 }
            }
        }
    }
}

#Preview {
    UserSectionView(user: UserPreviewData.user)
}
