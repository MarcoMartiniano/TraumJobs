//
//  NotificationTypesSheet.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

struct NotificationTypesSheet: View {
    @Binding var selectedTypes: [NotificationType]
    let options: [NotificationType]
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(options) { option in
                    MultipleSelectionRow(
                        title: option.rawValue,
                        isSelected: selectedTypes.contains(option)
                    ) {
                        toggleSelection(option)
                    }
                }
            }
            .navigationTitle("Benachrichtigungsarten")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleSelection(_ option: NotificationType) {
        if selectedTypes.contains(option) {
            selectedTypes.removeAll { $0 == option }
        } else {
            selectedTypes.append(option)
        }
    }
}

#Preview {
    NotificationTypesSheet(
        selectedTypes: .constant(UserPreviewData.selectedTypes),
        options: NotificationType.allCases
    )
}
