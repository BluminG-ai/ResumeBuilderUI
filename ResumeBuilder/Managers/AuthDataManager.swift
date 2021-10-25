//
//  AuthDataManager.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import Firebase
import CryptoKit
import Foundation
import GoogleSignIn
import AuthenticationServices

/// Authentication data manager
class AuthDataManager: NSObject, ObservableObject, GIDSignInDelegate, ASAuthorizationControllerDelegate {
    
    /// Dynamic properties that the UI will react to
    @Published var isAuthenticated: Bool = false
    
    /// Private properties
    private var currentNonce: String?
    
    func startGoogleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    func startAppleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil { return }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        auth(credentials: credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            presentAlert(title: "Oops", message: error.localizedDescription)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { return }
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString, rawNonce: nonce)
            auth(credentials: credential)
        }
    }
}

// MARK: - Firebase auth
extension AuthDataManager {
    func auth(credentials: AuthCredential) {
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let errorMessage = error?.localizedDescription {
                presentAlert(title: "Oops", message: errorMessage)
            } else if authResult != nil {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            }
        }
    }
    
    /// Required for Apple SignIn
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

/// Present auth error alert
func presentAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
}
