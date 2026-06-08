//
//  Job+Array.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 01.03.26.
//

import Foundation

// MARK: - Job Array Helpers
extension Array where Element == Job {
    
    /// Returns how many jobs contain the given skillType
    func jobCount(for skillType: SkillType) -> Int {
        self.filter { job in
            job.skills.contains { $0.skillType == skillType }
        }.count
    }
    
    /// Returns formatted German text for the job count
    func jobText(for skillType: SkillType) -> String {
        let count = self.jobCount(for: skillType)
        return count == 1 ? "1 Stelle" : "\(count) Stellen"
    }
}
