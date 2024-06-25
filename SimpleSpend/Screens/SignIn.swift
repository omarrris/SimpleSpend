import SwiftUI
import AuthenticationServices

struct SignIn: View {
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack {
            Image ("simplespendmain")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 200)
                .padding(.top, -50)
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authorization):
                    handleAuthorization(authorization: authorization)
                case .failure(let error):
                    print("Authorization failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(width: 200, height: 45)
            .padding()
            
            
        }
    }
    private func handleAuthorization(authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("User ID: \(userIdentifier)")
            print("User Full Name: \(String(describing: fullName))")
            print("User Email: \(String(describing: email))")
            
            UserDefaults.standard.set(userIdentifier, forKey: "userIdentifier")
                       
                       // Update the sign-in state
                       isSignedIn = true
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(isSignedIn: .constant(false))
    }
}

