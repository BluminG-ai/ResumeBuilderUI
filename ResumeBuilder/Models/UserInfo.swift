//
//  UserInfo.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import UIKit
import SwiftUI

/// User details model
class UserInfo: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var position: String = ""
    
    @Published var address: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var website: String = ""
    
    /// Dictionary data used to save the model on user defaults
    var dictionary: [String: Any] {
        [
            "firstName": firstName, "lastName": lastName, "position": position,
            "address": address, "phone": phone, "email": email, "website": website
        ]
    }
    
    /// Initializer with dictionary
    convenience init(dictionary: [String: Any]) {
        self.init()
        firstName = dictionary["firstName"] as? String ?? ""
        lastName = dictionary["lastName"] as? String ?? ""
        position = dictionary["position"] as? String ?? ""
        address = dictionary["address"] as? String ?? ""
        phone = dictionary["phone"] as? String ?? ""
        email = dictionary["email"] as? String ?? ""
        website = dictionary["website"] as? String ?? ""
    }
    
    /// Defines when education entry is valid
    var isValid: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty
            && !lastName.trimmingCharacters(in: .whitespaces).isEmpty
            && !phone.trimmingCharacters(in: .whitespaces).isEmpty
            && !email.trimmingCharacters(in: .whitespaces).isEmpty
            && !website.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    /// Formatted details
    var initials: String {
        if firstName.count > 0 && lastName.count > 0 {
            return "\(firstName.first!)\(lastName.first!)"
        }
        return ""
    }
    
    /// Preview model
    static var preview: UserInfo {
        let model = UserInfo()
        model.firstName = "John"
        model.lastName = "Smith"
        model.position = "Software Developer"
        model.address = "1234 Main Street, New York"
        model.phone = "555-444-7777"
        model.email = "j.smith@gmail.com"
        model.website = "www.linkedin.com/jsmith"
        return model
    }
}
