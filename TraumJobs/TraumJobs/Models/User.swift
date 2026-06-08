//
//  User.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftData
import Foundation

@Model
class User {

    var id: UUID = UUID()
    var name: String
    var email: String
    var password: String
    var birthDate: Date?
    var city: String

    @Relationship(deleteRule: .cascade)
    var jobs: [Job] = []

    @Relationship(deleteRule: .cascade)
    var skills: [Skill] = []

    init(
        name: String,
        password: String,
        email: String,
        birthDate: Date?,
        city: String = ""
    ) {
        self.name = name
        self.password = password
        self.email = email
        self.birthDate = birthDate
        self.city = city

        let defaultSkills = SkillType.allCases
            .map {
                Skill(
                    user: self,
                    skillType: $0,
                    isDefault: true,
                    isSelected: true
                )
            }

        self.skills = defaultSkills
    }
}
