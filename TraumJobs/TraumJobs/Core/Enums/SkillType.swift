//
//  Technology.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

enum SkillType: String, CaseIterable, Codable, Identifiable {
    var id: String { rawValue }
    
    // Default
    case none = "Keine Fähigkeit"

    // Back-end
    case java = "Java"
    case kotlin = "Kotlin"
    case python = "Python"
    case nodeJS = "Node.js"
    case rubyOnRails = "Ruby on Rails"
    
    // Front-end / Mobile
    case react = "React"
    case reactNative = "React Native"
    case objectiveC = "Objective-C"
    case swiftUI = "SwiftUI"
    case flutter = "Flutter"
    case android = "Android"
    
    // DevOps / Infra
    case docker = "Docker"
    case kubernetes = "Kubernetes"
    case aws = "AWS"
    case terraform = "Terraform"
    case git = "Git"
    
    // MARK: - Icon Name
    var iconName: String {
        switch self {
        case .none: return "icon_empty"
        
        // Back-end
        case .java: return "icon_java"
        case .kotlin: return "icon_kotlin"
        case .python: return "icon_python"
        case .nodeJS: return "icon_nodejs"
        case .rubyOnRails: return "icon_ruby-on-rails"
        
        // Front-end / Mobile
        case .react: return "icon_react"
        case .reactNative: return "icon_reactnative"
        case .objectiveC: return "icon_objectivec"
        case .swiftUI: return "icon_swiftui"
        case .flutter: return "icon_flutter"
        case .android: return "icon_android"
        
        // DevOps / Infra
        case .docker: return "icon_docker"
        case .kubernetes: return "icon_kubernetes"
        case .aws: return "icon_aws"
        case .terraform: return "icon_terraform"
        case .git: return "icon_git"
        }
    }
}
