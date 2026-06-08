//
//  Language.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 24.02.26.
//

import Foundation

enum Language: String, CaseIterable, Codable, Identifiable {
    case deutsch = "Deutsch"
    case englisch = "Englisch"
    case spanisch = "Spanisch"
    
    var id: String { rawValue }
}
