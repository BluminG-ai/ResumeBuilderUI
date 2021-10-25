//
//  SoftwareTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// A tab to select software skills
struct SoftwareTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showSkillsSelector: Bool = false
    @State private var shouldRefreshList: Bool = true
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Any software skills to brag about?")
                    .font(.system(size: 22)).bold()
                Text("Select a skill then rate it")
                VStack(spacing: 20) {
                    ForEach(0..<manager.software.count, id: \.self) { id in
                        VStack(spacing: 10) {
                            HStack {
                                Text(manager.software[id].softwareType.rawValue).bold()
                                Spacer()
                                Button(action: {
                                    manager.software.remove(at: id)
                                }, label: {
                                    Image(systemName: "trash").foregroundColor(.red)
                                })
                            }
                            HStack {
                                ForEach(0..<SkillLevel.allCases.count, id: \.self, content: { index in
                                    Text(SkillLevel.allCases[index].rawValue)
                                        .foregroundColor(
                                            shouldRefreshList && manager.software[id].skillLevel == SkillLevel.allCases[index] ? .accentColor : .gray
                                        )
                                        .onTapGesture {
                                            UIImpactFeedbackGenerator().impactOccurred()
                                            manager.software[id].skillLevel = SkillLevel.allCases[index]
                                            shouldRefreshList = false
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                shouldRefreshList = true
                                            }
                                        }
                                })
                                Spacer()
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 10)
                        )
                    }
                }
                Button(action: {
                    showSkillsSelector = true
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle").font(.system(size: 18, weight: .bold))
                        Text("Add a new Skill").bold()
                        Spacer()
                    }
                })
            }.padding(30)
            Spacer(minLength: 100)
        })
        .actionSheet(isPresented: $showSkillsSelector, content: {
            ActionSheet(title: Text("Software Skills"), message: Text("Choose a Skill"), buttons: SkillButtons)
        })
    }
    
    /// Skills buttons
    private var SkillButtons: [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()
        SoftwareType.allCases.forEach { skill in
            if !manager.software.compactMap({ $0.softwareType }).contains(skill) && skill != .none {
                buttons.append(ActionSheet.Button.default(Text(skill.rawValue), action: {
                    let model = SoftwareSkill()
                    model.softwareType = skill
                    manager.software.append(model)
                }))
            }
        }
        buttons.append(ActionSheet.Button.cancel())
        return buttons
    }
}

// MARK: - Preview UI
struct SoftwareTabView_Previews: PreviewProvider {
    static var previews: some View {
        SoftwareTabView(manager: PDFManager())
    }
}
