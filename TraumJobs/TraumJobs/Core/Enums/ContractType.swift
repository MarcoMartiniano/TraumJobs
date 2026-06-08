//
//  ContractType.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

enum ContractType: String, CaseIterable, Codable {
    case notInformed = "Nicht angegeben"
    case unbefristet = "Unbefristeter Vertrag"
    case befristet = "Befristeter Vertrag"
    case zeitarbeit = "Zeitarbeitsvertrag"
    case freelancer = "Freelancer"
}
