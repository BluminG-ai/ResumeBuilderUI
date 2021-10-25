//
//  BasicTemplate.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// PDF resume template
struct BasicTemplate: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(manager.userInfo.firstName) \(manager.userInfo.lastName)").bold()
                        Text(manager.userInfo.position)
                            .font(.system(size: 18 * manager.scaleFactor.rawValue))
                            .padding(.bottom, 2 * manager.scaleFactor.rawValue)
                        
                        Text("Phone").bold()
                            .font(.system(size: 15 * manager.scaleFactor.rawValue))
                            + Text("  \(manager.userInfo.phone)")
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        
                        Text("Email").bold()
                            .font(.system(size: 15 * manager.scaleFactor.rawValue))
                            + Text("  \(manager.userInfo.email)")
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        
                        Text(manager.summary)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        
                        ExperienceView
                        EducationView
                        SoftwareView
                        
                        VStack(alignment: .leading) {
                            Text("SKILLS").bold()
                                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                                .padding(.top, 20 * manager.scaleFactor.rawValue)
                            Divider()
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
    
    /// Education view
    private var EducationView: some View {
        VStack(alignment: .leading) {
            Text("EDUCATION").bold()
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.top, 20 * manager.scaleFactor.rawValue)
            Divider()
            
            ForEach(0..<manager.education.count, id: \.self, content: { id in
                HStack(alignment: .top) {
                    Text(manager.education[id].startEndYear).bold()
                        .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        .padding(.top, 5 * manager.scaleFactor.rawValue)
                    Spacer(minLength: 50 * manager.scaleFactor.rawValue)
                    VStack(alignment: .trailing) {
                        Text(manager.education[id].institution)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.education[id].major)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                    }
                }
            })
        }
    }
    
    /// Experience view
    private var ExperienceView: some View {
        VStack(alignment: .leading) {
            Text("EXPERIENCE").bold()
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.top, 20 * manager.scaleFactor.rawValue)
            Divider()
            
            ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                HStack(alignment: .top) {
                    Text(manager.workExperience[id].startEndDetails).bold()
                        .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        .padding(.top, 5 * manager.scaleFactor.rawValue)
                    Spacer(minLength: 50 * manager.scaleFactor.rawValue)
                    VStack(alignment: .trailing) {
                        Text(manager.workExperience[id].business)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.workExperience[id].position)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                    }
                }
            })
        }
    }
    
    /// Software skills
    private var SoftwareView: some View {
        VStack(alignment: .leading) {
            Text("SOFTWARE").bold()
                .font(.system(size: 18 * manager.scaleFactor.rawValue))
                .padding(.top, 20 * manager.scaleFactor.rawValue)
            Divider()
            ForEach(0..<manager.software.count, id: \.self, content: { id in
                HStack(alignment: .center) {
                    Text(manager.software[id].softwareType.rawValue).bold()
                        .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        .padding(.top, 5 * manager.scaleFactor.rawValue)
                    Spacer()
                    Text(manager.software[id].skillLevel.rawValue)
                        .lineLimit(1)
                        .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        .padding(.top, 5 * manager.scaleFactor.rawValue)
                }
            })
        }
    }
}

// MARK: - Preview UI
struct BasicTemplate_Previews: PreviewProvider {
    static var previews: some View {
        BasicTemplate(manager: PDFManager.preview)
            .previewLayout(.fixed(width: CGFloat(AppConfig.pageWidth), height: CGFloat(AppConfig.pageHeight)))
    }
}
