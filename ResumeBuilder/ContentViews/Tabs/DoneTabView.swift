//
//  DoneTabView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI

/// Last tab showing a list of PDF templates
struct DoneTabView: View {
    
    @ObservedObject var manager: PDFManager
    @State private var showAlert: Bool = false
    @State private var showPreview: Bool = false
    @State private var selectedTemplate: AnyView? {
        didSet { showPreview = true }
    }
    
    // MARK: - Main rendering function
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            if selectedTemplate != nil {
                NavigationLink(
                    destination: PDFViewerContentView(manager: manager, template: selectedTemplate!),
                    isActive: $showPreview,
                    label: { EmptyView() }).hidden()
            }
            
            Spacer(minLength: 20)
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    Text("Choose a template below")
                        .font(.system(size: 22)).bold()
                    Spacer()
                }
            }.padding([.leading, .trailing, .top], 30)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], content: {
                ForEach(0..<PDFManager.templates(manager: manager).count, id: \.self, content: { id in
                    PDFManager.templates(manager: PreviewManager)[id]
                        .frame(height: CGFloat((Double(UIScreen.main.bounds.width/2) * AppConfig.pageHeight) / AppConfig.pageWidth) - 40)
                        .clipped()
                        .background(Rectangle().foregroundColor(.white)
                                        .shadow(color: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), radius: 5))
                        .padding(10)
                        .onTapGesture {
                            if manager.isTemplateReady {
                                selectedTemplate = PDFManager.templates(manager: manager)[id]
                            } else {
                                showAlert = true
                            }
                        }
                })
            }).padding([.leading, .trailing], 25)
            Spacer(minLength: 50)
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Missing Details"), message: Text("Make sure you provide all the details for the user, contacts and more"), dismissButton: .cancel())
        })
    }
    
    /// Preview manager
    private var PreviewManager: PDFManager {
        let manager = PDFManager.preview
        manager.scaleFactor = .thumbnail
        return manager
    }
}

// MARK: - Preview UI
struct DoneTabView_Previews: PreviewProvider {
    static var previews: some View {
        DoneTabView(manager: PDFManager())
    }
}
