//
//  TraumJobsApp.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 09.06.26.
//

import SwiftUI
import SwiftData

@main
struct TraumJobsApp: App {
    @State private var session: SessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
                .modelContainer(try! ModelContainer.makeAppContainer())
        }
    }
}
