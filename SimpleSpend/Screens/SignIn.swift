import SwiftUI

struct SignIn: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("simplespendmain")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .padding(.top, -50)
                
                NavigationLink(destination: ContentView()) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(25)
                }
                .padding()
            }
            .darkMode()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
            .darkMode()
    }
}
