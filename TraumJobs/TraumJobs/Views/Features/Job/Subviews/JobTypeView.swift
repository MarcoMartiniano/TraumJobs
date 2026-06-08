//
//  JobTypeView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

import SwiftUI
import SwiftData

struct JobTypeView: View {

    // MARK: - Environment & State
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    
    private let manager = JobManager()
    
    let selectedSkill: Skill
    
    @Query(sort: \Job.startDate, order: .reverse)
    private var allJobs: [Job]
    
    @State private var selectedJob: Job? = nil

    // MARK: - Filter jobs by logged-in user and selected skill
    private var filteredJobs: [Job] {
        guard let userId = session.currentUserId else { return [] }
        return allJobs.filter { job in
            job.user.id == userId &&
            job.skills.contains(where: { $0.id == selectedSkill.id })
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Group {
                if filteredJobs.isEmpty {
                    EmptyStateView(skillName: selectedSkill.name)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filteredJobs) { job in
                            JobTypeRowView(job: job)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                                )
                                // MARK: - Delete swipe action
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        manager.delete(job, in: context)
                                    } label: {
                                        Label("Löschen", systemImage: AppIcons.trash)
                                    }
                                }
                                // MARK: - Toggle favorite swipe action
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        manager.toggleFavorite(job, in: context)
                                    } label: {
                                        Label(
                                            job.isFavorite ? "Nicht Favorit" : "Favorit",
                                            systemImage: job.isFavorite ? AppIcons.heartSlashFill : AppIcons.heartFill
                                        )
                                    }
                                    .tint(job.isFavorite ? .gray : .pink)
                                }
                                .onTapGesture {
                                    selectedJob = job
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(selectedSkill.name)
            .sheet(item: $selectedJob) { job in
                NavigationStack {
                    JobDetailSheetView(job: job)
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let skillName: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: AppIcons.briefcaseFill)
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Keine Jobs für \(skillName)")
                .foregroundColor(.gray)
                .font(.headline)
        }
        .padding()
    }
}

// MARK: - Skill Icon Row (Horizontal icons)
struct SkillIconRowView: View {
    
    let skills: [Skill]
    var maxVisible: Int = 4
    
    // Extract SkillType safely
    private var skillTypes: [SkillType] {
        skills.compactMap { $0.skillType }
    }
    
    var body: some View {
        if !skillTypes.isEmpty {
            HStack(spacing: 6) {
                
                ForEach(skillTypes.prefix(maxVisible), id: \.self) { skill in
                    Image(skill.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                if skillTypes.count > maxVisible {
                    Text("+\(skillTypes.count - maxVisible)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

#Preview("EmptyList") {
    JobTypeView(selectedSkill: UserPreviewData.skillSwift)
        .environment(SessionManager())
        .modelContainer(
            for: [
                User.self,
                Job.self,
                Skill.self
            ],
            inMemory: true
        )
}
