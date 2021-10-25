//
//  PDFManager.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI
import Foundation

// MARK: - Scale factor for the PDF template
enum ScaleFactorType: CGFloat {
    case thumbnail = 0.4
    case preview = 0.85
    case save = 1.9
}

/// Main class to build PDF files
class PDFManager: ObservableObject {
    
    /// Collect user details for the resume
    @Published var userInfo = UserInfo()
    
    /// Work experience details
    @Published var workExperience = [WorkExperience]()

    /// Education details
    @Published var education = [Education]()
    
    /// Generic skills
    @Published var skills = [String]()
    
    /// Software details
    @Published var software = [SoftwareSkill]()
    
    /// Short summary text. This text on the right is the placeholder
    static let summaryPlaceholder = "Write a short summary about yourself"
    @Published var summary: String = PDFManager.summaryPlaceholder
    
    /// Scale factor for the templates during grid view, preview and saving
    @Published var scaleFactor: ScaleFactorType = .thumbnail
    
    // MARK: - Init the manager with saved data
    init() {
        let userDefaults = UserDefaults.standard
        if let info = userDefaults.dictionary(forKey: "userInfo") {
            userInfo = UserInfo(dictionary: info)
        }
        if let experience = userDefaults.array(forKey: "workExperience") as? [[String: Any]] {
            experience.forEach { (dictionary) in
                workExperience.append(WorkExperience(dictionary: dictionary))
            }
        }
        if let ed = userDefaults.array(forKey: "education") as? [[String: Any]] {
            ed.forEach { (dictionary) in
                education.append(Education(dictionary: dictionary))
            }
        }
        if let soft = userDefaults.array(forKey: "software") as? [[String: Any]] {
            soft.forEach { (dictionary) in
                software.append(SoftwareSkill(dictionary: dictionary))
            }
        }
        skills = userDefaults.stringArray(forKey: "skills") ?? [String]()
        summary = userDefaults.string(forKey: "summary") ?? PDFManager.summaryPlaceholder
    }
    
    // MARK: - Validate the details
    // Check if the user provided the minimum necessary details
    var isTemplateReady: Bool {
        userInfo.isValid && summary != PDFManager.summaryPlaceholder && summary.count > 0
    }
    
    // MARK: - Save current details to User Defaults
    func saveCurrentDetails() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(userInfo.dictionary, forKey: "userInfo")
        userDefaults.setValue(workExperience.compactMap({ $0.dictionary }), forKey: "workExperience")
        userDefaults.setValue(education.compactMap({ $0.dictionary }), forKey: "education")
        userDefaults.setValue(skills, forKey: "skills")
        userDefaults.setValue(software.compactMap({ $0.dictionary }), forKey: "software")
        userDefaults.setValue(summary, forKey: "summary")
        userDefaults.synchronize()
    }
    
    // MARK: - PDF Template SwiftUI views
    /// Here you can add more of your PDF template SwiftUI views
    static func templates(manager: PDFManager) -> [AnyView] {
        [
            AnyView(BasicTemplate(manager: manager)),
            AnyView(BasicModernTemplate(manager: manager)),
            AnyView(SimpleTemplate(manager: manager)),
            AnyView(ColorHeaderTemplate(manager: manager)),
            AnyView(QuotesTemplate(manager: manager)),
            AnyView(PopularTemplate(manager: manager))
        ]
    }
    
    // MARK: - Preview manager
    /// This is just for the preview purposes during development and the Done tab
    static var preview: PDFManager {
        let manager = PDFManager()
        manager.scaleFactor = .preview
        manager.userInfo = UserInfo.preview
        manager.workExperience = [WorkExperience.preview, WorkExperience.preview]
        manager.education = [Education.preview, Education.preview]
        manager.skills = ["Multitasking", "Spanish language", "Design", "Leadership", "Visionary"]
        manager.software = [SoftwareSkill.preview, SoftwareSkill.preview]
        manager.summary = "Software developer for over 10 years Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        return manager
    }
}

// MARK: - Extension to help export a view as PDF
extension View {
    func exportToPDF(completion: @escaping (_ url: String?) -> Void) {
        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("resume.pdf")
        let pageSize = CGSize(width: AppConfig.pageWidth*2, height: AppConfig.pageHeight*2)
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.frame = CGRect(origin: .zero, size: pageSize)
        guard let root = UIApplication.shared.windows.first?.rootViewController else { return }
        root.addChild(hostingController)
        root.view.insertSubview(hostingController.view, at: 0)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        DispatchQueue.main.async {
            do {
                try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                    context.beginPage()
                    hostingController.view.layer.render(in: context.cgContext)
                })
                if AppConfig.showSavedPDFLocation {
                    print("PDF file saved to:\n\(outputFileURL.path)")
                }
                completion(outputFileURL.path)
            } catch {
                print("Could not create PDF file: \(error.localizedDescription)")
                completion(nil)
            }
            hostingController.removeFromParent()
            hostingController.view.removeFromSuperview()
        }
    }
}
