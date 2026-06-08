//
//  WorkMode.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 26.02.26.
//

enum WorkMode: String, CaseIterable, Codable {
    var id: String { rawValue }
    
    case onSite = "Präsenz"
    case homeOffice = "Homeoffice"
    case hybrid = "Hybrid"
    case remoteDE = "Remote (DE)"
    case remote = "Remote"
    case fieldWork = "Außendienst"
    case flexible = "Flexibel"

    // MARK: - Icon Name
    var iconName: String {
        switch self {
        case .onSite: return AppIcons.building2Fill              // office building
        case .homeOffice: return AppIcons.houseFill               // home
        case .hybrid: return AppIcons.houseAndFlagFill          // combination home + office
        case .remoteDE: return AppIcons.laptopcomputer            // laptop
        case .remote: return AppIcons.airplane       // remote worldwide
        case .fieldWork: return AppIcons.carFill                 // travel / field work
        case .flexible: return AppIcons.arrow2Circlepath        // flexible / rotating
        }
    }
}
