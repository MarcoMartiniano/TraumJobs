//
//  ModelContainer.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import SwiftData

extension ModelContainer {
    static func makeAppContainer() throws -> ModelContainer {
        return try ModelContainer(for: User.self, Job.self, Skill.self, )
    }
}
