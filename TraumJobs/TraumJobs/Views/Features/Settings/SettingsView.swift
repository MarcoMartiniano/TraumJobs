//
//  SettingsView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self)
    private var session
    
    // MARK: - State variables
    @State private var showNotificationTypes: Bool = false
    @State private var selectedNotificationTypes: [NotificationType] = []
    @State private var showEditSheet: Bool = false
    
    // Enum-based options
    let notificationOptions = NotificationType.allCases
    
    // MARK: - AppStorage values
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("appLanguage") private var appLanguageRawValue: String = Language.deutsch.rawValue
    @AppStorage("darkMode") private var darkMode: Bool = false
    @AppStorage("fontSize") private var fontSize: Double = 16
    
    var body: some View {
        NavigationStack {
            Form {
                // Display user information
                UserSectionView(user: session.currentUser(in: context))
 
                // Notification settings section
                NotificationSectionView(
                    notificationsEnabled: $notificationsEnabled,
                    selectedTypes: $selectedNotificationTypes,
                    options: notificationOptions,
                    showSheet: $showNotificationTypes
                )
                
                // Appearance and language section
                AppearanceSectionView(appLanguageRawValue: $appLanguageRawValue)
            }
            .navigationTitle("Einstellungen")
            
            // Show notification types sheet
            .sheet(isPresented: $showNotificationTypes) {
                NotificationTypesSheet(
                    selectedTypes: $selectedNotificationTypes,
                    options: notificationOptions
                )
            }
            
            // Show edit profile sheet
            .sheet(isPresented: $showEditSheet) {
                if let user = session.currentUser(in: context) {
                    EditUserSheet(user: user)
                        .environment(\.modelContext, context)
                        .environment(session)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Button to edit profile
                        Button {
                            showEditSheet = true
                        } label: {
                            Label("Profil bearbeiten", systemImage: AppIcons.pencil)
                        }
                        
                        // Button to log out
                        Button(role: .destructive) {
                            session.logout()
                        } label: {
                            Label("Abmelden", systemImage: AppIcons.power)
                        }
                        
                    } label: {
                        Image(systemName: AppIcons.ellipsisCircle)
                            .font(.title2)
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(SessionManager())
}
