//
//  JobTypeRowView.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 01.03.26.
//

import SwiftUI

struct JobTypeRowView: View {
    var job: Job
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
            
                Text(job.title)
                    .font(.system(size: 18))
                    .lineLimit(1)
                    .bold()

                Text("\(job.companyName), \(job.companyCity)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .italic()
                SkillIconRowView(skills: job.skills)
                
            }
            Spacer()
            VStack(alignment: .center, spacing: 6) {
                Image(systemName: job.workMode.iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(.blue)
                VStack(alignment: .center) {
                    Text(job.workMode.rawValue)
                        .font(.footnote)
                        .bold()
                    Text(CurrencyFormatter.euro(job.salary))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                
            }.padding(.trailing, 6)
            VStack {
                Image(systemName: job.isFavorite ? AppIcons.heartFill : AppIcons.heart)
                    .foregroundStyle(.red)
                    .font(.system(size: 18))
                Spacer()
            }
        }
    }
}

#Preview {
    JobTypeRowView(job: UserPreviewData.job)
}
