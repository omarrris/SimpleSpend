import SwiftUI
import RealmSwift
import AuthenticationServices

struct Settings: View {
    @Binding var isSignedIn: Bool
    @State private var showEraseConfirmation = false
    @State private var showSignOutConfirmation = false
    @State private var showDeleteAccountConfirmation = false

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Categories()) {
                    Text("Categories")
                }

                Button(role: .destructive) {
                    showEraseConfirmation = true
                } label: {
                    Text("Erase Data")
                }
                .alert(isPresented: $showEraseConfirmation) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("This action cannot be undone."),
                        primaryButton: .destructive(Text("Erase data")) {
                            let realm = try! Realm()
                            realm.beginWrite()
                            realm.deleteAll()
                            try! realm.commitWrite()
                        },
                        secondaryButton: .cancel()
                    )
                }

                Button(role: .cancel) {
                    showSignOutConfirmation = true
                } label: {
                    Text("Sign Out")
                }
                .alert(isPresented: $showSignOutConfirmation) {
                    Alert(
                        title: Text("Sign Out"),
                        message: Text("Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {
                            signOut()
                        },
                        secondaryButton: .cancel()
                    )
                }

                Button(role: .destructive) {
                    showDeleteAccountConfirmation = true
                } label: {
                    Text("Delete Account")
                }
                .alert(isPresented: $showDeleteAccountConfirmation) {
                    Alert(
                        title: Text("Delete Account"),
                        message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                        primaryButton: .destructive(Text("Delete Account")) {
                            deleteAccount()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationTitle("Settings")
            .padding(.top, 16)
        }
        .darkMode()
    }

    func signOut() {
        // Clear stored user data
        UserDefaults.standard.removeObject(forKey: "userIdentifier")
        
        // Update the sign-in state
        isSignedIn = false
    }

    func deleteAccount() {
        guard let userAccessToken = UserDefaults.standard.string(forKey: "userAccessToken") else {
            print("No user access token found")
            return
        }

        // Revoke the token
        revokeToken(userAccessToken: userAccessToken) { success in
            if success {
                // Clear stored user data
                UserDefaults.standard.removeObject(forKey: "userIdentifier")
                UserDefaults.standard.removeObject(forKey: "userAccessToken")
                
                // Update the sign-in state
                isSignedIn = false
            } else {
                print("Failed to revoke token")
            }
        }
    }

    func revokeToken(userAccessToken: String, completion: @escaping (Bool) -> Void) {
        let clientId = "YOUR_CLIENT_ID" // Replace with your actual client ID
        let clientSecret = "YOUR_CLIENT_SECRET" // Replace with your actual client secret
        
        let url = URL(string: "https://appleid.apple.com/auth/revoke")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = "client_id=\(clientId)&client_secret=\(clientSecret)&token=\(userAccessToken)&token_type_hint=access_token"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error revoking token: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(isSignedIn: .constant(true))
            .darkMode()
    }
}
