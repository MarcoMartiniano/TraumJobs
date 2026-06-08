//
//  NotificationType.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

enum NotificationType: String, CaseIterable, Identifiable {
    case messages = "Nachrichten"
    case emails = "E-Mails"
    case ads = "Werbung"
    
    var id: String { rawValue }
}
