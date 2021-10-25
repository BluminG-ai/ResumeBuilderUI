//
//  LogInContentView.swift
//  ResumeBuilder
//
//  Created by Apps4Devs on 25/10/21.
//

import SwiftUI
import AuthenticationServices

/// Login flow
struct LogInContentView: View {
    
    @ObservedObject var authManager: AuthDataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HeaderSectionView
                Spacer()
                BottomSectionView.padding(.top, 35).background(
                    RoundedCorner(radius: 45, corners: [.topLeft, .topRight])
                        .foregroundColor(.white).shadow(color: Color.black.opacity(0.2), radius: 10).edgesIgnoringSafeArea(.bottom)
                )
            }
        }
    }
    
    /// Header section view
    private var HeaderSectionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.square.fill.and.at.rectangle")
                .font(.system(size: 80)).foregroundColor(.accentColor)
            VStack(spacing: -5) {
                Text("Resume").font(.system(size: 25, weight: .medium))
                    .foregroundColor(Color(#colorLiteral(red: 0.4078431373, green: 0.4078431373, blue: 0.4078431373, alpha: 1)))
                Text("Builder").font(.system(size: 45, weight: .bold))
                    .foregroundColor(.accentColor)
            }
        }
    }
    
    /// Bottom section view
    private var BottomSectionView: some View {
        VStack {
            Text("Create your resume today\nwith just a few taps").italic()
                .font(.system(size: 19, weight: .light))
                .multilineTextAlignment(.center)
            VStack(spacing: 20) {
                GoogleSignInButton
                AppleSignInButton
            }.padding(30).background(
                RoundedRectangle(cornerRadius: 17).foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
            ).padding(35)
        }
    }
    
    /// Google SignIn button
    private var GoogleSignInButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            authManager.startGoogleSignIn()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.accentColor)
                HStack {
                    Image("google_logo")
                    Text("Sign with Google").font(.system(size: 19))
                        .foregroundColor(.white)
                }
            }.frame(height: 50)
        })
    }
    
    /// Sign In with Apple
    private var AppleSignInButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            authManager.startAppleSignIn()
        }, label: {
            SignInWithApple()
        }).frame(height: 50)
    }
}

// MARK: - Preview UI
struct LogInContentView_Previews: PreviewProvider {
    static var previews: some View {
        LogInContentView(authManager: AuthDataManager())
    }
}

struct SignInWithApple: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
