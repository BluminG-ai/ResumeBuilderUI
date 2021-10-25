//
//  ColorHeaderTemplate.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// PDF resume template
struct ColorHeaderTemplate: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading) {
                HeaderView
                
                VStack(alignment: .leading) {
                    SectionHeader(title: "Summary")
                    Text(manager.summary)
                        .lineLimit(4)
                        .font(.system(size: 14 * manager.scaleFactor.rawValue))
                    
                    ExperienceView
                    EducationView
                    SoftwareView
                    
                    VStack(alignment: .leading) {
                        SectionHeader(title: "Skills")
                        Text(manager.skills.joined(separator: "\n"))
                            .font(.system(size: 15 * manager.scaleFactor.rawValue))
                    }
                }.padding([.leading, .trailing], 30 * manager.scaleFactor.rawValue)
                
            }.font(.system(size: 25 * manager.scaleFactor.rawValue))
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        VStack(alignment: .center) {
            Rectangle().frame(width: 200 * manager.scaleFactor.rawValue, height: 2 * manager.scaleFactor.rawValue)
            Text("\(manager.userInfo.firstName) \(manager.userInfo.lastName)").bold()
            HStack(spacing: 10 * manager.scaleFactor.rawValue) {
                Text(manager.userInfo.phone)
                Rectangle()
                    .frame(width: 1 * manager.scaleFactor.rawValue, height: 10 * manager.scaleFactor.rawValue)
                Text(manager.userInfo.email)
                Rectangle()
                    .frame(width: 1 * manager.scaleFactor.rawValue, height: 10 * manager.scaleFactor.rawValue)
                Text(manager.userInfo.website)
            }.font(.system(size: 14 * manager.scaleFactor.rawValue))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(20 * manager.scaleFactor.rawValue)
        .background(Rectangle().foregroundColor(Color(#colorLiteral(red: 0.02946412936, green: 0.2949525714, blue: 0.5058609843, alpha: 1))))
    }
    
    /// Education view
    private var EducationView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Education")
            HStack(spacing: 20 * manager.scaleFactor.rawValue) {
                ForEach(0..<manager.education.count, id: \.self, content: { id in
                    VStack(alignment: .leading) {
                        Text(manager.education[id].startEndYear)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.education[id].institution)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.education[id].major).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 2 * manager.scaleFactor.rawValue)
                    }
                })
            }
        }
    }
    
    /// Experience view
    private var ExperienceView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Experience")
            HStack(spacing: 20 * manager.scaleFactor.rawValue) {
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    VStack(alignment: .leading) {
                        Text(manager.workExperience[id].business)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.workExperience[id].position)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        Text(manager.workExperience[id].startEndDetails).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 2 * manager.scaleFactor.rawValue)
                    }
                })
            }
        }
    }
    
    /// Software skills
    private var SoftwareView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Software")
            HStack(spacing: 20 * manager.scaleFactor.rawValue) {
                ForEach(0..<manager.software.count, id: \.self, content: { id in
                    VStack(alignment: .leading) {
                        Text(manager.software[id].softwareType.rawValue).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        HStack(spacing: 0) {
                            ForEach(0..<manager.software[id].skillLevel.index, id: \.self) { index in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 15 * manager.scaleFactor.rawValue))
                                    .foregroundColor(Color(#colorLiteral(red: 0.02946412936, green: 0.2949525714, blue: 0.5058609843, alpha: 1)))
                            }
                        }
                    }.padding(.top, 2 * manager.scaleFactor.rawValue)
                })
            }
        }
    }
    
    /// Create section header
    private func SectionHeader(title: String) -> some View {
        Text(title).bold()
            .padding(.top, 20 * manager.scaleFactor.rawValue)
            .background(Rectangle().frame(height: 2 * manager.scaleFactor.rawValue).offset(y: -5 * manager.scaleFactor.rawValue).foregroundColor(Color(#colorLiteral(red: 0.02946412936, green: 0.2949525714, blue: 0.5058609843, alpha: 1))))
            .foregroundColor(Color(#colorLiteral(red: 0.02946412936, green: 0.2949525714, blue: 0.5058609843, alpha: 1)))
            .font(.system(size: 20 * manager.scaleFactor.rawValue))
    }
}

// MARK: - Preview UI
struct ColorHeaderTemplate_Previews: PreviewProvider {
    static var previews: some View {
        ColorHeaderTemplate(manager: PDFManager.preview)
            .previewLayout(.fixed(width: CGFloat(AppConfig.pageWidth), height: CGFloat(AppConfig.pageHeight)))
    }
}

