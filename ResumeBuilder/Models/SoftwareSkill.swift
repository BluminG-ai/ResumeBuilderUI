//
//  SoftwareSkill.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import UIKit
import SwiftUI

/// Details about a software that the user has skills for
class SoftwareSkill: ObservableObject {
    
    @Published var softwareType: SoftwareType = .none
    @Published var skillLevel: SkillLevel = .basic
    
    /// Dictionary data used to save the model on user defaults
    var dictionary: [String: Any] {
        [
            "softwareType": softwareType.rawValue, "skillLevel": skillLevel.rawValue
        ]
    }
    
    /// Initializer with dictionary
    convenience init(dictionary: [String: Any]) {
        self.init()
        softwareType = SoftwareType(rawValue: dictionary["softwareType"] as? String ?? "") ?? .none
        skillLevel = SkillLevel(rawValue: dictionary["skillLevel"] as? String ?? "") ?? .basic
    }
    
    /// Preview model
    static var preview: SoftwareSkill {
        let model = SoftwareSkill()
        model.softwareType = .xcode
        model.skillLevel = SkillLevel.allCases.randomElement()!
        return model
    }
}

/// A defined number of softwares
enum SoftwareType: String, CaseIterable {
    case none
    case msWord = "Microsoft Word"
    case msExcell = "Microsoft Excell"
    case msPowerPoint = "Microsoft PowerPoint"
    case msWindowsServer = "Microsoft Windows Server"
    case php = "PHP"
    case html = "HTML"
    case xcode = "Xcode"
    case photoshop = "Photoshop"
    case wordpress = "Wordpress"
    case slack = "Slack"
    case keynote = "Keynote"
    case apache = "Apache"
    case machineLearning = "Machine Learning"
}

enum SkillLevel: String, CaseIterable, Identifiable {
    case basic = "Basic"
    case good = "Good"
    case veryGood = "Very Good"
    case excellent = "Excellent"
    
    var index: Int {
        SkillLevel.allCases.firstIndex(of: self)! + 1
    }
    
    var id: Int { hashValue }
}
