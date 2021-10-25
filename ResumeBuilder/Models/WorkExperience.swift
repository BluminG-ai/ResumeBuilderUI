//
//  WorkExperience.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import UIKit
import SwiftUI

/// Basic work experience details
class WorkExperience: ObservableObject {
    
    @Published var startMonth: String = ""
    @Published var startYear: String = ""
    @Published var endMonth: String = ""
    @Published var endYear: String = ""
    @Published var stillWorking: Bool = false
    
    @Published var position: String = ""
    @Published var business: String = ""
    
    /// Dictionary data used to save the model on user defaults
    var dictionary: [String: Any] {
        [
            "startMonth": startMonth, "startYear": startYear, "endMonth": endMonth,
            "endYear": endYear, "stillWorking": stillWorking, "position": position, "business": business
        ]
    }
    
    /// Initializer with dictionary
    convenience init(dictionary: [String: Any]) {
        self.init()
        startMonth = dictionary["startMonth"] as? String ?? ""
        startYear = dictionary["startYear"] as? String ?? ""
        endMonth = dictionary["endMonth"] as? String ?? ""
        endYear = dictionary["endYear"] as? String ?? ""
        stillWorking = dictionary["stillWorking"] as? Bool ?? false
        position = dictionary["position"] as? String ?? ""
        business = dictionary["business"] as? String ?? ""
    }
    
    /// Defines when a work experience entry is valid
    var isValid: Bool {
        !business.trimmingCharacters(in: .whitespaces).isEmpty
            && !position.trimmingCharacters(in: .whitespaces).isEmpty
            && !startYear.trimmingCharacters(in: .whitespaces).isEmpty
            && ((!stillWorking && !endYear.trimmingCharacters(in: .whitespaces).isEmpty) || stillWorking)
    }
    
    /// Formatted details
    var startEndDetails: String {
        let end = stillWorking ? "Present" : "\(endMonth)/\(endYear)"
        return "\(startMonth)/\(startYear) - \(end)"
    }
    
    /// Preview model
    static var preview: WorkExperience {
        let model = WorkExperience()
        model.startMonth = "10"
        model.startYear = "2020"
        model.endMonth = "02"
        model.endYear = "2021"
        model.stillWorking = false
        model.position = "Business Analyst"
        model.business = "Apple Inc."
        return model
    }
}
