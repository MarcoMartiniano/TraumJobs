//
//  JobType.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

enum JobType: String, CaseIterable, Codable {
    case vollzeit = "Vollzeit"
    case teilzeit = "Teilzeit"
    case minijob = "Minijob"
    case werkstudent = "Werkstudent"
    case ausbildung = "Ausbildung"
    case praktikum = "Praktikum"
    case freelancer = "Freiberuflich"
}
