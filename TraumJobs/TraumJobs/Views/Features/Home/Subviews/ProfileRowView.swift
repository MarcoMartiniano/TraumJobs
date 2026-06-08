//
//  ProfileRowView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

import SwiftUI

struct ProfileRowView: View {
    var name: String
    var email: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            Image(systemName: AppIcons.personCropCircleFill)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .clipShape(Circle())
                .shadow(radius: 2)
            
            // Name and Email
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let user = UserPreviewData.user
    ProfileRowView(name: user.name, email: user.email)
}
