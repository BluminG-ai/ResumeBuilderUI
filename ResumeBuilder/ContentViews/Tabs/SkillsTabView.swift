//
//  SkillsTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// Free form to add skills
struct SkillsTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var skill: String = ""
    @State private var bottomPadding: CGFloat = 30
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("What other skills do you have?")
                    .font(.system(size: 22)).bold()
                Text("Tell us about your skills. Add only the most important skills")
                VStack(spacing: 20) {
                    CustomTextField(text: $skill, placeholderText: "ex.: Multi-tasking")
                        .disableAutocorrection(true).textCase(.lowercase)
                    ForEach(0..<manager.skills.count, id: \.self, content: { id in
                        HStack {
                            Text(manager.skills[id]).bold()
                            Spacer()
                            Button(action: {
                                manager.skills.remove(at: id)
                            }, label: {
                                Image(systemName: "trash").foregroundColor(.red)
                            })
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 10)
                        )
                    })
                }
                Button(action: {
                    if !skill.trimmingCharacters(in: .whitespaces).isEmpty {
                        manager.skills.append(skill)
                        skill = ""
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle").font(.system(size: 18, weight: .bold))
                        Text("Add this skill").bold()
                        Spacer()
                    }
                })
                Spacer(minLength: bottomPadding)
            }.padding(30)
            Spacer(minLength: 100)
        })
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                bottomPadding = 280
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                bottomPadding = 100
            }
        })
    }
}

// MARK: - Preview UI
struct SkillsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SkillsTabView(manager: PDFManager())
    }
}
