//
//  WorkTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// Work experience tab
struct WorkTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showAddWorkFlow: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Your work experience").font(.system(size: 22)).bold()
                Text("We recommend you add the most recent 1-2 companies that you've worked for")
                ForEach(0..<manager.workExperience.count, id: \.self, content: { id in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(manager.workExperience[id].business).bold()
                            Text(manager.workExperience[id].position).opacity(0.75)
                        }
                        Spacer()
                        Button(action: {
                            manager.workExperience.remove(at: id)
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
                    showAddWorkFlow = true
                }, label: {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle").font(.system(size: 18, weight: .bold))
                        Text("Add Work Experience").bold()
                        Spacer()
                    }
                })
                Spacer(minLength: 100)
            }.padding(30)
        })
        .sheet(isPresented: $showAddWorkFlow, content: {
            AddWorkExperience(manager: manager)
        })
    }
}

/// Add work experience view/modal
struct AddWorkExperience: View {
    
    @ObservedObject var manager: PDFManager
    @ObservedObject var workModel = WorkExperience()
    @Environment(\.presentationMode) var presentation
    @State private var bottomPadding: CGFloat = 30
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Your work experience")
                    .font(.system(size: 22)).bold()
                Text("What was the componay that you've worked or still working for?")
                VStack(spacing: 35) {
                    CustomTextField(text: $workModel.business, placeholderText: "Company LLC.")
                    CustomTextField(text: $workModel.position, titleText: "What was your position?",
                                    placeholderText: "Associate")
                    CustomTextField(text: $workModel.startMonth, formatter: .month, titleText: "What month did you start?",
                                    placeholderText: "month").keyboardType(.numberPad)
                    CustomTextField(text: $workModel.startYear, formatter: .year, titleText: "What year did you start?",
                                    placeholderText: "year").keyboardType(.numberPad)
                    HStack {
                        Text("Are you still working here?")
                            .font(.system(size: 22)).bold()
                        Spacer()
                        Toggle("", isOn: $workModel.stillWorking).labelsHidden().accentColor(.accentColor)
                    }.padding(.bottom, 20)
                    if workModel.stillWorking == false {
                        CustomTextField(text: $workModel.endMonth, formatter: .month, titleText: "What month did you stop working?",
                                        placeholderText: "month").keyboardType(.numberPad)
                        CustomTextField(text: $workModel.endYear, formatter: .year, titleText: "What year did you stop working?",
                                        placeholderText: "year").keyboardType(.numberPad)
                    }
                    Button(action: {
                        UIImpactFeedbackGenerator().impactOccurred()
                        if workModel.isValid {
                            manager.workExperience.append(workModel)
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
struct WorkTabView_Previews: PreviewProvider {
    static var previews: some View {
        WorkTabView(manager: PDFManager())
    }
}
