//
//  MultipleSelectionRow.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

struct MultipleSelectionRow: View {
    
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                
                if isSelected {
                    Image(systemName: AppIcons.checkmark)
                        .foregroundColor(.blue)
                }
            }
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    VStack {
        MultipleSelectionRow(
            title: NotificationType.messages.rawValue,
            isSelected: false,
            action: {})
        MultipleSelectionRow(
            title: NotificationType.emails.rawValue,
            isSelected: true,
            action: {})
        MultipleSelectionRow(
            title: NotificationType.ads.rawValue,
            isSelected: true,
            action: {})
    }

}
