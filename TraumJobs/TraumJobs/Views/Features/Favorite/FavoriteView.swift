//
//  FavoriteView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 01.03.26.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self)
    private var session
    
    private var manager = JobManager()

    @Query(
        filter: #Predicate<Job> { job in
            job.isFavorite == true
        },
        sort: \Job.title
    )
    private var favoriteJobs: [Job]
    
    @State private var selectedJob: Job? = nil
    
//    // Filter also by the logged-in user
    private var filteredJobs: [Job] {
        guard let userId = session.currentUserId else { return [] }
        return favoriteJobs.filter { $0.user.id == userId }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                // MARK: - Empty state when no favorites
                if filteredJobs.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: AppIcons.heartSlashFill)
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Keine Favoriten gefunden")
                            .font(.headline)
                        
                        Text("Sie haben noch keinen Job als Favorit markiert.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 100)
                } else {
                    // MARK: - List of favorite jobs
                    List {
                        ForEach(filteredJobs) { job in
                            JobTypeRowView(job: job)
                            
                            // Swipe to delete
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    manager.delete(job, in: context)
                                } label: {
                                    Label("Löschen", systemImage: AppIcons.trash)
                                }
                            }
                            
                            // Swipe to remove from favorites
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    manager.toggleFavorite(job, in: context)
                                } label: {
                                    Label(
                                        "Entfernen",
                                        systemImage: AppIcons.heartSlashFill
                                    )
                                }
                                .tint(.gray)
                            }
                            
                            // Tap to open job detail
                            .onTapGesture {
                                selectedJob = job
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Favoriten")
            
            // MARK: - Sheet for job details
            .sheet(item: $selectedJob) { job in
                NavigationStack {
                    JobDetailSheetView(job: job)
                }
            }
        }
    }
}

#Preview {
    FavoriteView()
        .environment(SessionManager())
        .modelContainer(
            for: [Job.self],
            inMemory: true
        )
}
