//
//  ResumeBuilderApp.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleMobileAds

@main
struct ResumeBuilderApp: App {
    
    @ObservedObject private var authManager = AuthDataManager()
    @State private var didConfigureProject: Bool = false
    
    // MARK: - Main rendering function
    var body: some Scene {
        configureProject()
        return WindowGroup {
            if authManager.isAuthenticated {
                DashboardContentView()
            } else {
                LogInContentView(authManager: authManager).onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance().handle(url)
                })
            }
        }
    }
    
    /// One time configuration when the app launches
    private func configureProject() {
        DispatchQueue.main.async {
            if didConfigureProject == false {
                didConfigureProject = true
                FirebaseApp.configure()
                GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
                GIDSignIn.sharedInstance().delegate = authManager
                GADMobileAds.sharedInstance().start(completionHandler: nil)
                
                /// Check if the user is logged in already
                if Auth.auth().currentUser != nil {
                    self.authManager.isAuthenticated = true
                }
            }
        }
    }
}

// MARK: - Useful extensions
extension String {
    var formattedWebsite: String {
        if lowercased().contains("http") || contains("https") {
            return self
        }
        return self.count > 3 ? "https://\(self.replacingOccurrences(of: " ", with: ""))" : ""
    }
    
    var formattedPhoneNumber: String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
