//
//  JobView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI
import SwiftData

struct JobView: View {
    
    // MARK: - Environment & Context
    @Environment(SessionManager.self)
    private var session
    @Environment(\.modelContext) private var context
    @Binding var selectedTab: MainTab
    
    // MARK: - Queries
    @Query(sort: \Job.title, order: .forward) private var allJobs: [Job]
    @Query(sort: \Skill.name) private var allSkills: [Skill]
    
    // MARK: - State
    @State private var showAddSheet = false
    
    // MARK: - Filtered Skills & Jobs
    
    /// Selected skills of the logged-in user
    private var selectedSkills: [Skill] {
        guard let userId = session.currentUserId else { return [] }

        return allSkills
            .filter { $0.user?.id == userId && $0.isSelected }
            .sorted {
                let noneName = SkillType.none.rawValue

                if $0.name == noneName { return true }
                if $1.name == noneName { return false }

                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }
    
    /// Jobs of the logged-in user
    private var filteredJobs: [Job] {
        guard let userId = session.currentUserId else { return [] }
        return allJobs.filter { $0.user.id == userId }
    }
    
    /// Count jobs per skill
    private var jobsCountBySkill: [UUID: Int] {
        var dict: [UUID: Int] = [:]
        for job in filteredJobs {
            for skill in job.skills {
                dict[skill.id, default: 0] += 1
            }
        }
        return dict
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    if selectedSkills.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: AppIcons.sparklesRectangleStack)
                                .font(.system(size: 50))
                                .foregroundStyle(.blue)

                            Text("Keine Skills ausgewählt")
                                .font(.headline)

                            Text("Wähle deine Skills aus oder erstelle einen neuen Skill, um Jobs zu organisieren und zu verfolgen.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Button {
                                selectedTab = .skills
                            } label: {
                                Label("Neuer Skill hinzufügen", systemImage: AppIcons.plus)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)

                    } else {
                        ForEach(selectedSkills) { skill in
                            NavigationLink(
                                destination: JobTypeView(selectedSkill: skill)
                            ) {
                                JobRowView(
                                    label: skill.name,
                                    description: jobCountText(for: skill),
                                    iconName: skill.imageData == nil ? skill.skillType?.iconName : nil,
                                    uiImage: skill.imageData != nil ? UIImage(data: skill.imageData!) : nil
                                )
                            }
                            
                            Divider()
                                .padding(.leading, 60)
                        }                .background(Color.white)
                    }
                }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        HStack {
                            Text("Neuer Job")
                                .font(.system(size: 14))
                                .bold()
                            Image(systemName: AppIcons.plus)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            if let _ = session.currentUser(in: context) {
                JobAddView()
                    .environment(\.modelContext, context)
                    .environment(session)
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Returns job count text (singular/plural) in German
    private func jobCountText(for skill: Skill) -> String {
        let count = jobsCountBySkill[skill.id] ?? 0
        return count == 1 ? "1 Job" : "\(count) Jobs"
    }
}

// MARK: - Job Row View
struct JobRowView: View {
    var label: String
    var description: String
    var iconName: String? = nil
    var uiImage: UIImage? = nil  // Custom image for user-added skills

    var body: some View {
        HStack(spacing: 16) {
            
            // Icon / Image
            HStack {
                if let image = uiImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else if let iconName {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: AppIcons.starFill)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: AppIcons.chevronRight)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

#Preview("JobView empty") {
    JobView(selectedTab: .constant(.skills))
        .environment(SessionManager())
        .modelContainer(
            for: [Job.self, Skill.self],
            inMemory: true
        )
}
