//
//  RootView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI

struct RootView: View {
    @Environment(SessionManager.self) private var session
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
                    .environment(session)
            }
            .tabItem {
                Label("Home", systemImage: AppIcons.houseFill)
            }
            .tag(
                MainTab.home
            )
            
            NavigationStack {
                JobView(selectedTab: $selectedTab)
                    .environment(session)
            }
            .tabItem {
                Label("Jobs", systemImage: AppIcons.briefcaseFill)
            }
            .tag(
                MainTab.jobs
            )
            
            NavigationStack {
                FavoriteView()
                    .environment(session)
            }
            .tabItem {
                Label("Favoriten", systemImage: AppIcons.heartFill)
            }
            .tag(
                MainTab.favorites
            )
            
            NavigationStack {
                SkillView()
                    .environment(session)
            }
            .tabItem {
                Label("Skills", systemImage: AppIcons.brainHeadProfile)
            }
            .tag(
                MainTab.skills
            )
        }
    }
}

#Preview {
    RootView()
        .environment(SessionManager())
}
