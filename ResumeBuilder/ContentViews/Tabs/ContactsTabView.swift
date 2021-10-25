//
//  ContactsTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// Contacts view
struct ContactsTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var bottomPadding: CGFloat = 30
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Phone, Email and Website?")
                    .font(.system(size: 22)).bold()
                Text("How would you like a potential employer to contact you?")
                VStack(spacing: 35) {
                    CustomTextField(text: $manager.userInfo.email, placeholderText: "example@gmail.com")
                        .keyboardType(.emailAddress).disableAutocorrection(true).textCase(.lowercase)
                    CustomTextField(text: $manager.userInfo.phone, formatter: .phone, placeholderText: "(555) 456-7890")
                        .keyboardType(.numberPad)
                    CustomTextField(text: $manager.userInfo.website, formatter: .website, placeholderText: "www.example.com")
                        .disableAutocorrection(true).textCase(.lowercase)
                    CustomTextField(text: $manager.userInfo.address, placeholderText: "123 Main Street, New York, NY")
                }
                Text("You'll most likely be contacted by a recruiter via email or phone number, so it's very important to include an email address.")
                    .opacity(0.4).padding(.top, 20)
                Spacer(minLength: bottomPadding)
            }.padding(30)
            Spacer(minLength: 100)
        })
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                bottomPadding = 250
            }
            NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                bottomPadding = 30
            }
        })
    }
}

// MARK: - Preview UI
struct ContactsTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsTabView(manager: PDFManager())
    }
}
