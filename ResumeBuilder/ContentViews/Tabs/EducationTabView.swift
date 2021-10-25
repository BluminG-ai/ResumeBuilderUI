//
//  EducationTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// A tab to enter education details
struct EducationTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showAddEducationFlow: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("School, University?").font(.system(size: 22)).bold()
                Text("We recommend you add the latest institution that you've graduated from")
                ForEach(0..<manager.education.count, id: \.self, content: { id in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(manager.education[id].institution).bold()
                            Text(manager.education[id].major).opacity(0.75)
                        }
                        Spacer()
                        Button(action: {
                            manager.education.remove(at: id)
                        }, label: {
                            Image(systemName: "trash").foregroundColor(.red)
                        })
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 10)
                    )
                })
                Button(action: {
                    showAddEducationFlow = true
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle").font(.system(size: 18, weight: .bold))
                        Text("Add Education").bold()
                        Spacer()
                    }
                })
                Spacer(minLength: 100)
            }.padding(30)
        })
        .sheet(isPresented: $showAddEducationFlow, content: {
            AddEducation(manager: manager)
        })
    }
}

/// Add education details
struct AddEducation: View {
    
    @ObservedObject var manager: PDFManager
    @ObservedObject var educationModel = Education()
    @Environment(\.presentationMode) var presentation
    @State private var bottomPadding: CGFloat = 30
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("About your education")
                    .font(.system(size: 22)).bold()
                Text("Which school/university did you attend and when?")
                VStack(spacing: 35) {
                    CustomTextField(text: $educationModel.institution, placeholderText: "Harvard")
                    CustomTextField(text: $educationModel.major, titleText: "Your major/degree",
                                    placeholderText: "Computer Science")
                    CustomTextField(text: $educationModel.startYear, formatter: .year, titleText: "What year did you start?",
                                    placeholderText: "year").keyboardType(.numberPad)
                    HStack {
                        Text("Are you still studying here?")
                            .font(.system(size: 22)).bold()
                        Spacer()
                        Toggle("", isOn: $educationModel.stillInSchool).labelsHidden().accentColor(.accentColor)
                    }.padding(.bottom, 20)
                    if educationModel.stillInSchool == false {
                        CustomTextField(text: $educationModel.endYear, formatter: .year, titleText: "What year did you graduate?",
                                        placeholderText: "year").keyboardType(.numberPad)
                    }
                    Button(action: {
                        UIImpactFeedbackGenerator().impactOccurred()
                        if educationModel.isValid {
                            manager.education.append(educationModel)
                        }
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, y: 5)
                            Text("Save").font(.system(size: 24))
                                .foregroundColor(.white).bold()
                        }
                    }).frame(height: 60).padding([.leading, .trailing], 30)
                } .disableAutocorrection(true)
                Spacer(minLength: bottomPadding)
            }.padding(30)
            Spacer(minLength: 100)
        })
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                bottomPadding = 80
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                bottomPadding = 30
            }
        })
    }
}

// MARK: - Preview UI
struct EducationTabView_Previews: PreviewProvider {
    static var previews: some View {
        EducationTabView(manager: PDFManager())
    }
}
