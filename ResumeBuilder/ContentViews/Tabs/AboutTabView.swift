//
//  AboutTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// About tab
struct AboutTabView: View {
    
    @ObservedObject var manager: PDFManager
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                Text("Let's get started with your name.")
                    .font(.system(size: 22)).bold()
                Text("What is your name?")
                VStack(spacing: 35) {
                    CustomTextField(text: $manager.userInfo.firstName, placeholderText: "First Name")
                    CustomTextField(text: $manager.userInfo.lastName, placeholderText: "Last Name")
                }
                Text("Usually only the first and last name is required, but feel free to include your middle name as part of the first name")
                    .opacity(0.4).padding(.top, 20)
            }.padding(30)
            Spacer(minLength: 100)
        })
    }
}

// MARK: - Preview UI
struct AboutTabView_Previews: PreviewProvider {
    static var previews: some View {
        AboutTabView(manager: PDFManager())
    }
}
