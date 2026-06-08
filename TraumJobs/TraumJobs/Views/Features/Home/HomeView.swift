//
//  HomeView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

import SwiftUI

struct HomeView: View {
    @Environment(SessionManager.self)
    private var session
    @Environment(\.modelContext) private var context
    @State private var showSettings: Bool = false
    
    var body: some View {
        let user = session.currentUser(in: context)
        
        NavigationStack {
            VStack(alignment: .center) {
                ProfileRowView(
                    name: user?.name ?? "User not found",
                    email: user?.email ?? "E-mail not found"
                )
                Spacer()
            }.padding()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: AppIcons.gearshapeFill)
                            .font(.title2)
                    }
                    .accessibilityLabel("Einstellungen öffnen")
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environment(\.modelContext, context)
                    .environment(session)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(SessionManager())
}
