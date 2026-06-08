//
//  JobAddView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftUI
import SwiftData

struct JobAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    
    private let manager = JobManager()

    // MARK: - Job Fields
    @State private var title: String = ""
    @State private var jobPosition: String = ""
    @State private var salary: String = ""
    
    @State private var companyName: String = ""
    @State private var companyCity: String = ""
    @State private var workLocation: String = ""
    
    @State private var contractType: ContractType = .unbefristet
    @State private var jobType: JobType = .vollzeit
    @State private var workMode: WorkMode = .onSite
    
    @State private var startDate: Date? = Date()
    @State private var endDate: Date? = nil

    @State private var selectedSkills: Set<Skill> = []
    
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingPicker = false

    var body: some View {
        NavigationStack {
            Form {
                BasicInformationSection(title: $title, jobPosition: $jobPosition, salary: $salary)
                
                CompanyInformationSection(companyName: $companyName, companyCity: $companyCity, workLocation: $workLocation)
                
                JobConfigurationSection(contractType: $contractType, jobType: $jobType, workMode: $workMode)
                
                EmploymentPeriodSection(contractType: $contractType, startDate: $startDate, endDate: $endDate)
                
                SkillSelectionSection(selectedSkills: $selectedSkills)
                
                PhotoPickerSection(selectedImage: $selectedImage, isShowingPicker: $isShowingPicker)
            }
            .navigationTitle("Job hinzufügen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("X") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Job speichern") {
                        guard let user = session.currentUser(in: context) else { return }

                        manager.saveJob(
                            title: title,
                            jobPosition: jobPosition,
                            salary: Double(salary) ?? 0,
                            companyName: companyName,
                            companyCity: companyCity,
                            workLocation: workLocation,
                            contractType: contractType,
                            jobType: jobType,
                            workMode: workMode,
                            startDate: startDate,
                            endDate: endDate,
                            skills: Array(selectedSkills),
                            selectedImage: selectedImage,
                            user: user,
                            in: context
                        )
                        
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Basic Information Section
struct BasicInformationSection: View {
    @Binding var title: String
    @Binding var jobPosition: String
    @Binding var salary: String

    var body: some View {
        Section(header: Text("Jobinformationen")) {
            TextField("Berufsbezeichnung", text: $title)
            TextField("Position", text: $jobPosition)
            TextField("Jahresgehalt (€)", text: $salary)
                .keyboardType(.decimalPad)
        }
    }
}

// MARK: - Company Information Section
struct CompanyInformationSection: View {
    @Binding var companyName: String
    @Binding var companyCity: String
    @Binding var workLocation: String

    var body: some View {
        Section(header: Text("Firmeninformationen")) {
            TextField("Firmenname", text: $companyName)
            TextField("Stadt des Unternehmens", text: $companyCity)
            TextField("Arbeitsort", text: $workLocation)
        }
    }
}

// MARK: - Job Configuration Section
struct JobConfigurationSection: View {
    @Binding var contractType: ContractType
    @Binding var jobType: JobType
    @Binding var workMode: WorkMode

    var body: some View {
        Section(header: Text("Job-Konfiguration")) {
            Picker("Vertragsart", selection: $contractType) {
                ForEach(ContractType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }

            Picker("Job-Typ", selection: $jobType) {
                ForEach(JobType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }

            Picker("Arbeitsmodus", selection: $workMode) {
                ForEach(WorkMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue)
                }
            }
        }
    }
}

struct EmploymentPeriodSection: View {
    
    @Binding var contractType: ContractType
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    @State private var addEndDate: Bool = false
    
    var body: some View {
        Section(header: Text("Beschäftigungszeitraum")) {
            
            // Start date picker
            DatePicker(
                "Startdatum",
                selection: startDateBinding,
                displayedComponents: .date
            )
            
            endDateContent
        }
    }
    
    // MARK: - End Date Logic
    
    @ViewBuilder
    private var endDateContent: some View {
        
        switch contractType {
            
        case .unbefristet:
            // Unlimited contract → always no end date
            staticEndText("Unbefristet")
                .onAppear { endDate = nil }
            
        case .befristet, .zeitarbeit:
            // Fixed contracts → end date required
            endDatePicker
            
        case .notInformed:
            // Not informed → show static "Nicht angegeben"
            staticEndText("Nicht angegeben")
            
        case .freelancer:
            // Freelancer → user can decide
            Toggle("Enddatum hinzufügen", isOn: $addEndDate)
            freelancerEndDateSection
        }
    }
    
    // MARK: - Components
    
    /// Reusable binding for start date
    private var startDateBinding: Binding<Date> {
        Binding(
            get: { startDate ?? Date() },
            set: { startDate = $0 }
        )
    }
    
    /// Reusable binding for end date
    private var endDateBinding: Binding<Date> {
        Binding(
            get: { endDate ?? Date() },
            set: { endDate = $0 }
        )
    }
    
    /// Reusable End Date picker
    private var endDatePicker: some View {
        DatePicker(
            "Enddatum",
            selection: endDateBinding,
            displayedComponents: .date
        )
    }
    
    /// Reusable static row for displaying end date text
    private func staticEndText(_ text: String) -> some View {
        HStack {
            Text("Enddatum")
            Spacer()
            Text(text)
                .foregroundColor(.gray)
        }
    }
    
    /// Freelancer section with optional end date
    private var freelancerEndDateSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if addEndDate {
                endDatePicker
            } else {
                staticEndText("Nicht angegeben")
            }
        }
    }
}

struct SkillSelectionSection: View {

    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self)
    private var session
    
    @Binding var selectedSkills: Set<Skill>

    @Query(sort: \Skill.name)
    private var allSkills: [Skill]

    private var userSkills: [Skill] {
        guard let userId = session.currentUserId else { return [] }
        return allSkills.filter { $0.user?.id == userId }
    }
    

    var body: some View {
        Section(header: Text("Fähigkeiten")) {

            ForEach(userSkills) { skill in
                HStack(spacing: 12) {

                    if let data = skill.imageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    } else if let type = skill.skillType {
                        Image(type.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }

                    Text(skill.name)

                    Spacer()

                    if selectedSkills.contains(skill) {
                        Image(systemName: AppIcons.checkmarkCircleFill)
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggle(skill)
                }
            }
        }
    }

    private func toggle(_ skill: Skill) {
        if selectedSkills.contains(skill) {
            selectedSkills.remove(skill)
        } else {
            selectedSkills.insert(skill)
        }
    }
}

struct PhotoPickerSection: View {
    // MARK: - Bindings to hold the selected image and control the picker presentation
    @Binding var selectedImage: UIImage?
    @Binding var isShowingPicker: Bool
    
    var body: some View {
        // Section for job image
        Section(header: Text("Job-Bild")) {
            VStack {
                // Display the selected image if available
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                } else {
                    // Placeholder text when no image is selected
                    Text("Kein Bild ausgewählt")
                        .foregroundColor(.gray)
                }
                
                // Button to open the image picker
                Button("Bild auswählen") {
                    isShowingPicker = true
                }
                // Present the ImagePicker sheet
                .sheet(isPresented: $isShowingPicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
        }
    }
}

#Preview {
    JobAddView()
        .environment(SessionManager())
}
