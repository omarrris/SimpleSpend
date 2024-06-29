import SwiftUI
import RealmSwift
import AuthenticationServices

struct Settings: View {
    @Binding var isSignedIn: Bool
    @State private var showEraseConfirmation = false
    @State private var showSignOutConfirmation = false

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
            }
            .navigationTitle("Settings")
            .padding(.top, 16)
        }
    }

    func signOut() {
        // Clear stored user data
        UserDefaults.standard.removeObject(forKey: "userIdentifier")
        
        // Update the sign-in state
        isSignedIn = false
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(isSignedIn: .constant(true))
    }
}
