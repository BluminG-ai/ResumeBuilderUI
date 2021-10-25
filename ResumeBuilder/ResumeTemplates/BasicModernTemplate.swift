//
//  BasicModernTemplate.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// PDF resume template
struct BasicModernTemplate: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HeaderView
                        
                        Text(manager.summary)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        
                        ExperienceView
                        EducationView
                        SoftwareView
                        
                        VStack(alignment: .leading) {
                            SectionHeader(title: "SKILLS")
                            Text(manager.skills.joined(separator: ", "))
                                .font(.system(size: 15 * manager.scaleFactor.rawValue))
                        }
                        
                    }.font(.system(size: 25 * manager.scaleFactor.rawValue))
                    Spacer()
                }
                Spacer()
            }.padding(20 * manager.scaleFactor.rawValue)
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        VStack {
            ZStack {
                Circle().stroke(lineWidth: 2 * manager.scaleFactor.rawValue)
                Text(manager.userInfo.initials).bold()
                    .font(.system(size: 30 * manager.scaleFactor.rawValue))
            }.frame(height: 70 * manager.scaleFactor.rawValue)
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
            Divider()
        }.frame(maxWidth: .infinity).padding(.top, 10 * manager.scaleFactor.rawValue)
    }
    
    /// Education view
    private var EducationView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "EDUCATION")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<manager.education.count, id: \.self, content: { id in
                    VStack(alignment: .trailing) {
                        Text(manager.education[id].startEndYear)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.education[id].institution)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.education[id].major).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Divider()
                    }.padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                })
            })
        }
    }
    
    /// Experience view
    private var ExperienceView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "EXPERIENCE")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    VStack(alignment: .trailing) {
                        Text(manager.workExperience[id].business)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.workExperience[id].position)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.workExperience[id].startEndDetails).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Divider()
                    }.padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                })
            })
        }
    }
    
    /// Software skills
    private var SoftwareView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "SOFTWARE")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<manager.software.count, id: \.self, content: { id in
                    VStack(alignment: .trailing) {
                        Text(manager.software[id].softwareType.rawValue).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        HStack {
                            ForEach(0..<manager.software[id].skillLevel.index, id: \.self, content: { index in
                                Circle()
                                    .frame(width: 10 * manager.scaleFactor.rawValue, height: 10 * manager.scaleFactor.rawValue)
                            })
                        }
                        Text(manager.software[id].skillLevel.rawValue)
                            .lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Divider()
                    }.padding([.leading, .trailing], 20 * manager.scaleFactor.rawValue)
                })
            })
        }
    }
    
    /// Create section header
    private func SectionHeader(title: String) -> some View {
        HStack(alignment: .bottom) {
            Text(title).bold()
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.top, 20 * manager.scaleFactor.rawValue)
            Rectangle().frame(height: 1 * manager.scaleFactor.rawValue)
        }
    }
}

// MARK: - Preview UI
struct BasicModernTemplate_Previews: PreviewProvider {
    static var previews: some View {
        BasicModernTemplate(manager: PDFManager.preview)
            .previewLayout(.fixed(width: CGFloat(AppConfig.pageWidth), height: CGFloat(AppConfig.pageHeight)))
    }
}
