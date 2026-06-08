//
//  sss.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import Foundation

struct ValidationHelper {
    
    static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let emailFormat =
        "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return predicate.evaluate(with: trimmed)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
