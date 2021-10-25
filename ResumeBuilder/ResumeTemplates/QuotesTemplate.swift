//
//  QuotesTemplate.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// PDF resume template
struct QuotesTemplate: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            Rectangle().frame(width: 180 * manager.scaleFactor.rawValue)
                .foregroundColor(Color(#colorLiteral(red: 0.9528475404, green: 0.953006804, blue: 0.9528264403, alpha: 1)))
            
            VStack(alignment: .leading) {
                HeaderView
                
                HStack(alignment: .top) {
                    SideSectionView

                    VStack(alignment: .leading) {
                        SectionHeader(title: "Summary")
                        Text(manager.summary)
                            .lineLimit(4).multilineTextAlignment(.center)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        ExperienceView.padding(.top, 15 * manager.scaleFactor.rawValue)
                        EducationView.padding(.top, 15 * manager.scaleFactor.rawValue)
                    }.padding([.leading, .trailing], 30 * manager.scaleFactor.rawValue)
                }
            }.font(.system(size: 25 * manager.scaleFactor.rawValue))
            
        }
    }
    
    /// Header view
    private var HeaderView: some View {
        HStack {
            VStack(alignment: .leading, spacing: -5) {
                Text(manager.userInfo.firstName).bold()
                Text(manager.userInfo.lastName)
            }.font(.system(size: 35 * manager.scaleFactor.rawValue))
            Spacer()
            Image(systemName: "quote.bubble")
                .font(.system(size: 50 * manager.scaleFactor.rawValue))
        }
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing], 25 * manager.scaleFactor.rawValue)
        .padding(.top, 25 * manager.scaleFactor.rawValue)
        .padding(.bottom, 15 * manager.scaleFactor.rawValue)
    }
    
    private var SideSectionView: some View {
        VStack(alignment: .leading, spacing: 30 * manager.scaleFactor.rawValue) {
            VStack(alignment: .leading, spacing: 10 * manager.scaleFactor.rawValue) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text(manager.userInfo.phone)
                }
                HStack {
                    Image(systemName: "envelope.fill")
                    Text(manager.userInfo.email)
                }
                HStack {
                    Image(systemName: "globe")
                    Text(manager.userInfo.website)
                }
            }.font(.system(size: 14 * manager.scaleFactor.rawValue))
            
            VStack(alignment: .leading, spacing: 5 * manager.scaleFactor.rawValue) {
                Text("Skills").bold()
                Divider()
                Text(manager.skills.joined(separator: ", "))
                    .padding(.top, 10 * manager.scaleFactor.rawValue)
            }.font(.system(size: 15 * manager.scaleFactor.rawValue))
            
            VStack(alignment: .leading, spacing: 5 * manager.scaleFactor.rawValue) {
                Text("Software").bold()
                Divider()
                VStack(alignment: .leading, spacing: 20 * manager.scaleFactor.rawValue) {
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
                        }
                    })
                }.padding(.top, 10 * manager.scaleFactor.rawValue)
            }.font(.system(size: 15 * manager.scaleFactor.rawValue))
        }
        .font(.system(size: 25 * manager.scaleFactor.rawValue))
        .frame(maxWidth: 150 * manager.scaleFactor.rawValue)
        .padding([.leading, .trailing], 25 * manager.scaleFactor.rawValue)
        .padding(.top, 25 * manager.scaleFactor.rawValue)
    }
    
    /// Education view
    private var EducationView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Education")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<manager.education.count, id: \.self, content: { id in
                    VStack(alignment: .leading) {
                        Text(manager.education[id].startEndYear)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        Text(manager.education[id].institution)
                            .lineLimit(3)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                        HStack {
                            Text(manager.education[id].major).bold()
                                .font(.system(size: 14 * manager.scaleFactor.rawValue))
                                .padding(.top, 2 * manager.scaleFactor.rawValue)
                            Spacer()
                        }
                    }
                })
            })
        }
    }
    
    /// Experience view
    private var ExperienceView: some View {
        VStack(alignment: .leading) {
            SectionHeader(title: "Experience")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    VStack(alignment: .leading) {
                        Text(manager.workExperience[id].business)
                            .bold().lineLimit(1)
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 5 * manager.scaleFactor.rawValue)
                        HStack {
                            Text(manager.workExperience[id].position)
                                .lineLimit(3)
                                .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            Spacer()
                        }
                        Text(manager.workExperience[id].startEndDetails).bold()
                            .font(.system(size: 14 * manager.scaleFactor.rawValue))
                            .padding(.top, 2 * manager.scaleFactor.rawValue)
                    }
                })
            })
        }
    }
    
    /// Create section header
    private func SectionHeader(title: String) -> some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                Text(title).bold()
                    .foregroundColor(Color(#colorLiteral(red: 0.02946412936, green: 0.2949525714, blue: 0.5058609843, alpha: 1)))
                    .font(.system(size: 20 * manager.scaleFactor.rawValue))
                Divider()
            }
            Spacer()
        }
    }
}

// MARK: - Preview UI
struct QuotesTemplate_Previews: PreviewProvider {
    static var previews: some View {
        QuotesTemplate(manager: PDFManager.preview)
            .previewLayout(.fixed(width: CGFloat(AppConfig.pageWidth), height: CGFloat(AppConfig.pageHeight)))
    }
}
