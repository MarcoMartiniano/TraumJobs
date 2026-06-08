//
//  SkillView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 01.03.26.
//

import SwiftUI
import SwiftData

struct SkillView: View {
    @State private var selectedSkillTypes: Set<SkillType> = []
    @Environment(SessionManager.self)
    private var session
    
    var body: some View {
        SkillsListView()
            .environment(session)
    }
}

struct AddCustomSkillSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    let session: SessionManager
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Skill-Name", text: $name)
                
                Button {
                    showImagePicker.toggle()
                } label: {
                    HStack {
                        Text(selectedImage == nil ? "Bild auswählen" : "Bild ändern")
                        Spacer()
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                }
            }
            .navigationTitle("Neuer Skill")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern") {
                        saveSkill()
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
    
    private func saveSkill() {
        guard let currentUser = session.currentUser(in: context) else { return }

        let skill = Skill(
            user: currentUser,
            skillType: .none,
            imageData: selectedImage?.jpegData(compressionQuality: 0.8),
            isDefault: false,
            isSelected: true,
            name: name
        )

        context.insert(skill)

        do {
            try context.save()
            dismiss()
        } catch {
            print("Failed to save skill: \(error)")
        }
    }
}

struct SkillsListView: View {

    // MARK: - Environment
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self)
    private var session

    @State private var showAddSheet = false

    // MARK: - Query
    @Query(sort: \Skill.name)
    private var allSkills: [Skill]

    // MARK: - Filtrar por usuário logado
    private var userSkills: [Skill] {
        guard let userId = session.currentUserId else { return [] }
        return allSkills.filter { $0.user?.id == userId }
    }

    private var defaultSkills: [Skill] {
        userSkills.filter { $0.isDefault }
    }

    private var customSkills: [Skill] {
        userSkills.filter { !$0.isDefault }
    }

    var body: some View {
        NavigationStack {
            List {

               // MARK: - Default Skills
                if !defaultSkills.isEmpty {
                    Section("Standard Skills") {
                        ForEach(defaultSkills) { skill in
                            skillRow(skill)
                        }
                    }
                }

                // MARK: - Custom Skills
                if !customSkills.isEmpty {
                    Section("Eigene Skills") {
                        ForEach(customSkills) { skill in
                            skillRow(skill)
                        }
                        .onDelete(perform: deleteCustomSkill)
                    }
                }
            }
            .navigationTitle("Skills")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Fähigkeit hinzufügen", systemImage: AppIcons.plus)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddCustomSkillSheet(session: session)
            }
        }
    }

    // MARK: - Skill Row
    @ViewBuilder
    private func skillRow(_ skill: Skill) -> some View {
        HStack {

            if let data = skill.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else if let type = skill.skillType {
                Image(type.iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: AppIcons.starFill)
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Text(skill.name)

            Spacer()

            Image(systemName: skill.isSelected ? AppIcons.checkmarkCircleFill : AppIcons.circle)
                .foregroundStyle(skill.isSelected ? .blue : .gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggle(skill)
        }
    }

    // MARK: - Toggle
    private func toggle(_ skill: Skill) {
        skill.isSelected.toggle()

        do {
            try context.save()
        } catch {
            print("Failed to save toggle: \(error)")
        }
    }

    // MARK: - Delete Custom
    private func deleteCustomSkill(at offsets: IndexSet) {
        for index in offsets {
            let skill = customSkills[index]
            context.delete(skill)
        }

        do {
            try context.save()
        } catch {
            print("Failed to delete skill: \(error)")
        }
    }
}

#Preview {
    SkillView()
        .environment(SessionManager())
        .modelContainer(
            for: [Skill.self],
            inMemory: true
        )
}
