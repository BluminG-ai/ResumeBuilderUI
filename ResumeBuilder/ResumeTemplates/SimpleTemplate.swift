//
//  SimpleTemplate.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// PDF resume template
struct SimpleTemplate: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .trailing) {
                HeaderView
                
                Text(manager.summary)
                    .lineLimit(3)
                    .font(.system(size: 14 * manager.scaleFactor.rawValue))
                    .padding(.top, 5 * manager.scaleFactor.rawValue)
                
                ExperienceView
                EducationView
                SoftwareView
                
                VStack(alignment: .trailing) {
                    SectionHeader(title: "SKILLS")
                    HStack {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                            ForEach(0..<manager.skills.count, id: \.self, content: { id in
                                Text(manager.skills[id]).lineLimit(1)
                                    .font(.system(size: 15 * manager.scaleFactor.rawValue))
                                    .lineLimit(1).minimumScaleFactor(0.2)
                            })
                        })
                        Spacer(minLength: 60 * manager.scaleFactor.rawValue)
                    }
                }
                
            }
            .minimumScaleFactor(0.5)
            .font(.system(size: 25 * manager.scaleFactor.rawValue))
            .padding(20 * manager.scaleFactor.rawValue)
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        VStack(alignment: .trailing) {
            Rectangle().frame(height: 20 * manager.scaleFactor.rawValue).opacity(0.5)
                .foregroundColor(.orange)
            Text("\(manager.userInfo.firstName) \(manager.userInfo.lastName)").bold()
            Text(manager.userInfo.position)
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.bottom, 2 * manager.scaleFactor.rawValue)
            
            HStack(spacing: 10 * manager.scaleFactor.rawValue) {
                Text(manager.userInfo.phone)
                Rectangle()
                    .frame(width: 1 * manager.scaleFactor.rawValue, height: 10 * manager.scaleFactor.rawValue)
                Text(manager.userInfo.email)
                Rectangle()
                    .frame(width: 1 * manager.scaleFactor.rawValue, height: 10 * manager.scaleFactor.rawValue)
                Text(manager.userInfo.website)
            }.font(.system(size: 14 * manager.scaleFactor.rawValue))
            Rectangle().frame(height: 10 * manager.scaleFactor.rawValue).opacity(0.5)
        }.frame(maxWidth: .infinity).padding(.top, 10 * manager.scaleFactor.rawValue)
    }
    
    /// Education view
    private var EducationView: some View {
        VStack(alignment: .trailing) {
            SectionHeader(title: "EDUCATION")
            HStack {
                ForEach(0..<manager.education.count, id: \.self, content: { id in
                    VStack(alignment: .trailing) {
                        Text(manager.education[id].startEndYear).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.education[id].institution)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.education[id].major).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                    }
                    .padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                    .lineLimit(1).minimumScaleFactor(0.2)
                })
                Spacer(minLength: 60 * manager.scaleFactor.rawValue)
            }
        }
    }
    
    /// Experience view
    private var ExperienceView: some View {
        VStack(alignment: .trailing) {
            SectionHeader(title: "EXPERIENCE")
            HStack {
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    VStack(alignment: .trailing) {
                        Text(manager.workExperience[id].business).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.workExperience[id].position)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.workExperience[id].startEndDetails).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                    }
                    .padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                    .lineLimit(1).minimumScaleFactor(0.2)
                })
                Spacer(minLength: 60 * manager.scaleFactor.rawValue)
            }
        }
    }
    
    /// Software skills
    private var SoftwareView: some View {
        VStack(alignment: .trailing) {
            SectionHeader(title: "SOFTWARE")
            HStack {
                ForEach(0..<manager.software.count, id: \.self, content: { id in
                    HStack {
                        Text(manager.software[id].softwareType.rawValue).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.software[id].skillLevel.rawValue)
                            .lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                    }
                    .padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                    .lineLimit(1).minimumScaleFactor(0.2)
                })
                Spacer(minLength: 60 * manager.scaleFactor.rawValue)
            }
        }
    }
    
    /// Create section header
    private func SectionHeader(title: String) -> some View {
        VStack(alignment: .trailing) {
            Text(title).bold()
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.top, 20 * manager.scaleFactor.rawValue)
            Rectangle().frame(height: 5 * manager.scaleFactor.rawValue).opacity(0.5)
        }
    }
}

// MARK: - Preview UI
struct SimpleTemplate_Previews: PreviewProvider {
    static var previews: some View {
        SimpleTemplate(manager: PDFManager.preview)
            .previewLayout(.fixed(width: CGFloat(AppConfig.pageWidth), height: CGFloat(AppConfig.pageHeight)))
    }
}
