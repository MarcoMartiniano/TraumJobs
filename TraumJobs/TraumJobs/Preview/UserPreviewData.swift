//
//  PreviewData.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import Foundation
import SwiftData

struct UserPreviewData {
    
    static let user: User = {
        // MARK: - User
        let user = User(
            name: "John Doe",
            password: "1234",
            email: "john.doe@email.com",
            birthDate: Calendar.current.date(from: DateComponents(year: 1990, month: 5, day: 15))!,
            city: "Berlin"
        )
        
        // MARK: - Jobs
        let job1 = Job(
            title: "iOS Developer",
            jobPosition: "Senior iOS Entwickler",
            salary: 75000,
            companyName: "SAP",
            companyCity: "Walldorf",
            workLocation: "Berlin",
            contractType: .unbefristet,
            jobType: .vollzeit,
            workMode: .hybrid,
            startDate: Calendar.current.date(from: DateComponents(year: 2021, month: 3, day: 1))!,
            endDate: nil,
            user: user
        )
        
        let job2 = Job(
            title: "Mobile Engineer",
            jobPosition: "iOS Entwickler",
            salary: 60000,
            companyName: "Siemens",
            companyCity: "München",
            workLocation: "München",
            contractType: .befristet,
            jobType: .vollzeit,
            workMode: .onSite,
            startDate: Calendar.current.date(from: DateComponents(year: 2018, month: 6, day: 1))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2021, month: 2, day: 28)),
            user: user
        )
        
        // MARK: - Skills
        let sk = Skill()

        let skill1 = Skill(name: "Strong knowledge of Swift and SwiftUI", job: job1 )
        let skill2 = Skill(name: "Building modern declarative interfaces", job: job1)
        let skill3 = Skill(name: "Android development experience", job: job2)
        
        // Attach Skills aos Jobs
        job1.skills = [skill1, skill2]
        job2.skills = [skill2, skill3]
        
        // Attach Jobs ao User
        user.jobs = [job1, job2]
        
        return user
    }()
    
    // MARK: - Single Preview Objects
    static let job = Job(
        title: "Backend Developer",
        jobPosition: "Java Entwickler",
        salary: 68000,
        companyName: "BMW",
        companyCity: "München",
        workLocation: "Hybrid",
        contractType: .unbefristet,
        jobType: .vollzeit,
        workMode: .hybrid,
        startDate: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!,
        endDate: nil,
        user: user
    )
    
    static let skillAndroid = Skill(name: "Android development experience", job: job)
    static let skillSwift = Skill(name: "SwiftUi development experience", job: job)
    
    static let selectedTypes: [NotificationType] = [.emails, .messages]
}

//// MARK: - SessionManager preview data
//@MainActor
//struct SessionPreviewData {
//    static var session: SessionManager {
//        let session = SessionManager()
//        return session
//    }
    
  //  }
