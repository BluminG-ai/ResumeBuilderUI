//
//  PDFViewerContentView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import UIKit
import SwiftUI

/// A view to preview a PDF file
struct PDFViewerContentView: View {
    
    @ObservedObject var manager: PDFManager
    @Environment(\.presentationMode) var presentation
    @State private var shouldGoBack: Bool = false
    @State var template: AnyView
    
    // MARK: - Main rendering function
    var body: some View {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if manager.scaleFactor == .thumbnail && !shouldGoBack {
                manager.scaleFactor = .preview
            }
        }
        return ZStack {
            Color(#colorLiteral(red: 0.9489265084, green: 0.949085772, blue: 0.9704096913, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Saved version may look different").bold()
                    .padding([.leading, .trailing], 20)
                ZStack {
                    Color.white.shadow(color: Color.black.opacity(0.2), radius: 5)
                    if manager.scaleFactor == .preview {
                        template.clipped()
                    } else {
                        Text("please wait...").opacity(0.7)
                    }
                }.padding(10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("PDF Viewer")
        .navigationBarItems(leading: BackButton, trailing: SaveButton)
    }
    
    private var BackButton: some View {
        Button(action: {
            navigateBack()
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.left")
                Text("Back").bold()
            }
        })
    }
    
    private var SaveButton: some View {
        Button(action: {
            manager.scaleFactor = .save
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                template.exportToPDF { url in
                    if let urlString = url, let data = try? Data(contentsOf: URL(fileURLWithPath: urlString)) {
                        let share = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        UIApplication.shared.windows
                            .first?.rootViewController?.present(share, animated: true, completion: nil)
                        navigateBack()
                    }
                }
            }
        }, label: {
            Text("Save").bold()
        })
    }
    
    private func navigateBack() {
        shouldGoBack = true
        manager.scaleFactor = .thumbnail
        presentation.wrappedValue.dismiss()
    }
}

// MARK: - Preview UI
struct PDFViewerContentView_Previews: PreviewProvider {
    static var previews: some View {
        PDFViewerContentView(manager: PDFManager(), template: AnyView(BasicTemplate(manager: PDFManager())))
    }
}
