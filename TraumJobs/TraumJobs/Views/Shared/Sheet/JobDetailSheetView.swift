//
//  JobDetailView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI
import SwiftData

struct JobDetailSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var manager = JobManager()
    
    let job: Job
    
    // Controls the delete confirmation alert
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Job Image at the top
                JobImageView(imageData: job.imageData, height: 200)
                
                // MARK: - Job Info Card
                InfoCardView(title: "Jobinformationen", icon: AppIcons.briefcaseFill) {
                    VStack(spacing: 6) {
                        DetailRow(label: "Titel", value: job.title)
                        DetailRow(label: "Position", value: job.jobPosition)
                        DetailRow(label: "Gehalt", value: CurrencyFormatter.euro(job.salary))
                    }
                }
                
                // MARK: - Company Info Card
                InfoCardView(title: "Firmeninformationen", icon: AppIcons.building2Fill) {
                    VStack(spacing: 6) {
                        DetailRow(label: "Firmenname", value: job.companyName)
                        DetailRow(label: "Stadt", value: job.companyCity)
                        DetailRow(label: "Arbeitsort", value: job.workLocation)
                    }
                }
                
                // MARK: - Job Configuration Card
                InfoCardView(title: "Vertraginformationen", icon: AppIcons.gearshapeFill) {
                    VStack(spacing: 6) {
                        DetailRow(label: "Vertragsart", value: job.contractType.rawValue)
                        DetailRow(label: "Job-Typ", value: job.jobType.rawValue)
                        DetailRow(label: "Arbeitsmodus", value: job.workMode.rawValue, icon: job.workMode.iconName)
                    }
                }
                
                // MARK: - Employment Period Card
                InfoCardView(title: "Beschäftigungszeitraum", icon: AppIcons.calendar) {
                    VStack(spacing: 6) {
                        DetailRow(label: "Startdatum", value: job.startDate?.germanFormatted ?? "-")
                        DetailRow(label: "Enddatum", value: job.endDate?.germanFormatted ?? "Aktuelle Stelle", valueColor: job.endDate == nil ? .green : .primary)
                    }
                }
                
                // MARK: - Skills Card
                if !job.skills.isEmpty {
                    InfoCardView(title: "Fähigkeiten", icon: AppIcons.hammerFill) {
                        HStack {
                            Spacer()
                            ForEach(job.skills, id: \.id) { skill in
                                VStack {
                                    Image(skill.skillType?.iconName ?? "icon_empty")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                    Text(skill.name)
                                        .font(.footnote)
                                }
                                .padding(4)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Jobdetails")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Schließen") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    // Trigger confirmation alert
                    showDeleteAlert = true
                } label: {
                    Image(systemName: AppIcons.trash)
                }
            }
        }
        // Delete confirmation alert
        .alert("Job löschen?", isPresented: $showDeleteAlert) {
            
            Button("Abbrechen", role: .cancel) { }
            
            Button("Löschen", role: .destructive) {
                manager.delete(job, in: context)
                dismiss()
            }
            
        } message: {
            Text("Möchten Sie diesen Job wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.")
        }
        .background(Color(.white).ignoresSafeArea())
    }
}

// MARK: - JobImageView: Displays the job image or a placeholder if no image exists
struct JobImageView: View {
    
    let imageData: Data?  // The optional image data for the job
    let height: CGFloat    // Allows customizing the height of the image
    
    var body: some View {
        // Show the job image if available
        if let data = imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(height: height)
                .clipped()
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.bottom, 10)
        } else {
            // Show a placeholder if no image is available
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: height)
                .overlay(
                    Image(systemName: AppIcons.photo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                )
                .cornerRadius(12)
                .padding(.bottom, 10)
        }
    }
}

// MARK: - Reusable Card Component
struct InfoCardView<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                    Text(title)
                        .font(.headline)
                }
                Spacer()
            }.padding(.bottom, 6)
            
            VStack {
                content()
            }
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Reusable Detail Row
struct DetailRow: View {
    let label: String
    let value: String
    var icon: String? = nil
    var valueColor: Color = .primary
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.blue)
            }
            
            Text(value)
                .foregroundColor(valueColor)
                .font(.subheadline)
                .bold()
        }
    }
}

#Preview {
    JobDetailSheetView(job: UserPreviewData.job)
        .modelContainer(
            for: [Job.self, Skill.self],
            inMemory: true
        )
}
