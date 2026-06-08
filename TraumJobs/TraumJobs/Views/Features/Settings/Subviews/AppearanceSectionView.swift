//
//  AppearanceSectionView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 25.02.26.
//

import SwiftUI

struct AppearanceSectionView: View {
    
    @Binding var appLanguageRawValue: String
    
    var body: some View {
        Section(header: Text("Darstellung und Sprache")) {
            Picker("Sprache", selection: $appLanguageRawValue) {
                ForEach(Language.allCases) { language in
                    Text(language.rawValue).tag(language.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    AppearanceSectionView(appLanguageRawValue: .constant(Language.deutsch.rawValue))
}
