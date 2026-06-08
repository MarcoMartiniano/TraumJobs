//
//  Skill.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftData
import Foundation

@Model
class Skill {

    var id: UUID = UUID()
    var name: String
    var skillType: SkillType?
    var imageData: Data?

    var isDefault: Bool
    var isSelected: Bool
    
    @Relationship(inverse: \User.skills)
    var job: Job?

    @Relationship(inverse: \User.skills)
    var user: User?

    init(
        user: User? = nil,
        skillType: SkillType = .none,
        imageData: Data? = nil,
        isDefault: Bool = false,
        isSelected: Bool = true,
        name: String? = nil,
        job: Job? = nil,
    ) {
        self.user = user
        self.skillType = skillType
        self.imageData = imageData
        self.isDefault = isDefault
        self.isSelected = isSelected
        self.name = name ?? skillType.rawValue
        self.job = job
    }
}
