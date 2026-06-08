//
//  NotificationSectionView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

struct NotificationSectionView: View {
    
    @Binding var notificationsEnabled: Bool
    @Binding var selectedTypes: [NotificationType]
    let options: [NotificationType]
    @Binding var showSheet: Bool
    
    var body: some View {
        Section(header: Text("Benachrichtigungen")) {
            Toggle("Benachrichtigungen aktivieren", isOn: $notificationsEnabled)
            
            Button("Arten von Benachrichtigungen") {
                showSheet.toggle()
            }
            
            if !selectedTypes.isEmpty {
                Text("Ausgewählt: \(selectedTypes.map { $0.rawValue }.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    NotificationSectionView(
        notificationsEnabled: .constant(true),
        selectedTypes: .constant(UserPreviewData.selectedTypes),
        options: NotificationType.allCases,
        showSheet: .constant(false))
}
