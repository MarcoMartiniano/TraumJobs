//
//  JobManager.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 01.03.26.
//

import SwiftUI
import SwiftData

@MainActor
final class JobManager {

    // MARK: - Delete
    func delete(_ job: Job, in context: ModelContext) {
        do {
            context.delete(job)
            try context.save()
        } catch {
            print("Error deleting job:", error.localizedDescription)
        }
    }

    // MARK: - Save
    func saveJob(
        title: String,
        jobPosition: String,
        salary: Double,
        companyName: String,
        companyCity: String,
        workLocation: String,
        contractType: ContractType,
        jobType: JobType,
        workMode: WorkMode,
        startDate: Date?,
        endDate: Date?,
        skills: [Skill],
        selectedImage: UIImage?,
        user: User,
        in context: ModelContext
    ) {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)

        let newJob = Job(
            title: title,
            jobPosition: jobPosition,
            salary: salary,
            companyName: companyName,
            companyCity: companyCity,
            workLocation: workLocation,
            contractType: contractType,
            jobType: jobType,
            workMode: workMode,
            startDate: startDate,
            endDate: endDate,
            user: user,
            imageData: imageData
        )

        newJob.skills = skills

        context.insert(newJob)

        do {
            try context.save()
            print("Job successfully saved for user:", user.name)
        } catch {
            print("Failed to save job:", error)
        }
    }

    // MARK: - Favorite
    func toggleFavorite(_ job: Job, in context: ModelContext) {
        job.isFavorite.toggle()

        do {
            try context.save()
        } catch {
            print("Error updating favorite:", error.localizedDescription)
        }
    }
}
