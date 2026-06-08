//
//  Job.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftData
import Foundation

@Model
class Job {
    var id: UUID = UUID()

    var title: String
    var jobPosition: String
    var salary: Double
    var companyName: String
    var companyCity: String
    var workLocation: String
    var contractType: ContractType
    var jobType: JobType
    var workMode: WorkMode
    var startDate: Date?
    var endDate: Date?
    var isFavorite: Bool

    @Relationship(deleteRule: .cascade, inverse: \Skill.job)
    var skills: [Skill] = []

    @Relationship(inverse: \User.jobs)
    var user: User
    
    var imageData: Data? = nil

    init(
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
        user: User,
        skills: [Skill] = [],
        imageData: Data? = nil,
        isFavorite: Bool = false
    ) {
        self.title = title
        self.jobPosition = jobPosition
        self.salary = salary
        self.companyName = companyName
        self.companyCity = companyCity
        self.workLocation = workLocation
        self.contractType = contractType
        self.jobType = jobType
        self.workMode = workMode
        self.startDate = startDate
        self.endDate = endDate
        self.user = user
        self.skills = skills
        self.imageData = imageData
        self.isFavorite = isFavorite
    }
}
